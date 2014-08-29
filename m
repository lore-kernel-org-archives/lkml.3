Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaH2OZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:25:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49369 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbaH2OZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:25:39 -0400
Date: Fri, 29 Aug 2014 16:25:35 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Peter Chen <peter.chen@freescale.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        balbi@ti.com, gregkh@linuxfoundation.org, kishon@ti.com,
        stern@rowland.harvard.edu, sergei.shtylyov@cogentembedded.com,
        yoshihiro.shimoda.uh@renesas.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/9] usb: chipidea: move usb_otg into struct ci_hdrc
Message-ID: <20140829142535.GA16609@kwain>
References: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
 <1408722621-3635-9-git-send-email-antoine.tenart@free-electrons.com>
 <20140826102239.GD16758@peterchendt>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140826102239.GD16758@peterchendt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 26, 2014 at 06:22:40PM +0800, Peter Chen wrote:
> On Fri, Aug 22, 2014 at 05:50:19PM +0200, Antoine Ténart wrote:
> 
> If the common usb_otg and usb_phy struct still has another's pointer, you
> may not need to add this patch.

Except if we want to access the OTG member when not using an USB PHY.

> > diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
> > index 0b67d78dd953..0952d4adfa4c 100644
> > --- a/drivers/usb/chipidea/host.c
> > +++ b/drivers/usb/chipidea/host.c
> > @@ -85,13 +85,11 @@ static int host_start(struct ci_hdrc *ci)
> >  	if (ret) {
> >  		goto disable_reg;
> >  	} else {
> > -		struct usb_otg *otg = ci->usb_phy->otg;
> > +		struct usb_otg *otg = &ci->otg;
> >  
> >  		ci->hcd = hcd;
> > -		if (otg) {
> > -			otg->host = &hcd->self;
> > -			hcd->self.otg_port = 1;
> > -		}
> > +		otg->host = &hcd->self;
> > +		hcd->self.otg_port = 1;
> >  	}
> 
> You may need use other way to identify if otg is supported or not

How would you do that?

> > -	otg->usb_phy = ci->usb_phy;
> > -	otg->gadget = &ci->gadget;
> > -	ci->fsm.otg = otg;
> > -	ci->usb_phy->otg = ci->fsm.otg;
> > +	ci->otg.usb_phy = ci->usb_phy;
> > +	ci->fsm.otg = &ci->otg;
> >  	ci->fsm.power_up = 1;
> >  	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
> >  	ci->fsm.otg->state = OTG_STATE_UNDEFINED;
> 
> Why otg->gadget and ci->usb_phy->otg initialization are deleted?
> At least, the parameters of usb_otg_state_string at your 7th patch uses it.

Sure, I'll fix this

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
