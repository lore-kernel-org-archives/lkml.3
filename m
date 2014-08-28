Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaH1SPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:15:04 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:32300 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaH1SPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:15:02 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+3N/SIZx+tXNRwEc2BKzNB
Date: Thu, 28 Aug 2014 11:14:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: kishon@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/5] usb: phy: twl4030-usb: Remove unused irq_enabled
Message-ID: <20140828181457.GK16006@atomide.com>
References: <1409182091-31191-1-git-send-email-tony@atomide.com>
 <1409182091-31191-2-git-send-email-tony@atomide.com>
 <20140828022051.GB5273@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828022051.GB5273@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140827 19:21]:
> Hi,
> 
> On Wed, Aug 27, 2014 at 04:28:07PM -0700, Tony Lindgren wrote:
> > It's not being used any longer.
> > 
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > ---
> >  drivers/phy/phy-twl4030-usb.c     | 2 --
> >  drivers/usb/phy/phy-twl6030-usb.c | 2 --
> >  2 files changed, 4 deletions(-)
> > 
> > diff --git a/drivers/phy/phy-twl4030-usb.c b/drivers/phy/phy-twl4030-usb.c
> > index 9cd33a4..bc28ecc 100644
> > --- a/drivers/phy/phy-twl4030-usb.c
> > +++ b/drivers/phy/phy-twl4030-usb.c
> > @@ -164,7 +164,6 @@ struct twl4030_usb {
> >  	enum omap_musb_vbus_id_status linkstat;
> >  	bool			vbus_supplied;
> >  	u8			asleep;
> > -	bool			irq_enabled;
> >  
> >  	struct delayed_work	id_workaround_work;
> >  };
> > @@ -755,7 +754,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
> >  	 * set_host() and/or set_peripheral() ... OTG_capable boards
> >  	 * need both handles, otherwise just one suffices.
> >  	 */
> > -	twl->irq_enabled = true;
> >  	status = devm_request_threaded_irq(twl->dev, twl->irq, NULL,
> >  			twl4030_usb_irq, IRQF_TRIGGER_FALLING |
> >  			IRQF_TRIGGER_RISING | IRQF_ONESHOT, "twl4030_usb", twl);
> 
> can you split this into two patches ? drivers/phy will be taken by
> Kishon and drivers/usb/phy by me. another possibility is that I get an
> Acked-by from Kishon and I can take $subject as is.

Oops yes sorry I already forgot I'm patching twl6030 too. Below
is the updated version of this patch for Kishon with just the
twl4030 changes. I will post the twl6030 changes separately.

Regards,

Tony

8< ---------------------
From: Tony Lindgren <tony@atomide.com>
Date: Mon, 18 Aug 2014 07:54:16 -0700
Subject: [PATCH] usb: phy: twl4030-usb: Remove unused irq_enabled

It's not being used any longer.

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -164,7 +164,6 @@ struct twl4030_usb {
 	enum omap_musb_vbus_id_status linkstat;
 	bool			vbus_supplied;
 	u8			asleep;
-	bool			irq_enabled;
 
 	struct delayed_work	id_workaround_work;
 };
@@ -755,7 +754,6 @@ static int twl4030_usb_probe(struct platform_device *pdev)
 	 * set_host() and/or set_peripheral() ... OTG_capable boards
 	 * need both handles, otherwise just one suffices.
 	 */
-	twl->irq_enabled = true;
 	status = devm_request_threaded_irq(twl->dev, twl->irq, NULL,
 			twl4030_usb_irq, IRQF_TRIGGER_FALLING |
 			IRQF_TRIGGER_RISING | IRQF_ONESHOT, "twl4030_usb", twl);
