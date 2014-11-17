Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaKQKMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:12:22 -0500
Received: from down.free-electrons.com ([37.187.137.238]:46883 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751907AbaKQKMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:12:20 -0500
Date: Mon, 17 Nov 2014 11:01:09 +0100
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        p.zabel@pengutronix.de, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 08/13] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20141117100109.GA20934@kwain>
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com>
 <1415978763-27345-9-git-send-email-antoine.tenart@free-electrons.com>
 <20141114210832.GE16388@saruman>
 <20141114211052.GA8105@kwain>
 <20141114211334.GF16388@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141114211334.GF16388@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

On Fri, Nov 14, 2014 at 03:13:34PM -0600, Felipe Balbi wrote:
> On Fri, Nov 14, 2014 at 10:10:52PM +0100, Antoine Tenart wrote:
> > On Fri, Nov 14, 2014 at 03:08:32PM -0600, Felipe Balbi wrote:
> > > On Fri, Nov 14, 2014 at 04:25:58PM +0100, Antoine Tenart wrote:
> > > > Add a USB2 ChipIdea driver for ci13xxx, with optional PHY, clock
> > > > and DMA mask, to support USB2 ChipIdea controllers that don't need
> > > > specific functions.
> > > > 
> > > > Tested on the Marvell Berlin SoCs USB controllers.
> > > > 
> > > > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> > > > ---
> > > >  drivers/usb/chipidea/Makefile       |   1 +
> > > >  drivers/usb/chipidea/ci_hdrc_usb2.c | 117 ++++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 118 insertions(+)
> > > >  create mode 100644 drivers/usb/chipidea/ci_hdrc_usb2.c
> > > > 
> > > > diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
> > > > index 2f099c7df7b5..1fc86a2ca22d 100644
> > > > --- a/drivers/usb/chipidea/Makefile
> > > > +++ b/drivers/usb/chipidea/Makefile
> > > > @@ -10,6 +10,7 @@ ci_hdrc-$(CONFIG_USB_OTG_FSM)		+= otg_fsm.o
> > > >  
> > > >  # Glue/Bridge layers go here
> > > >  
> > > > +obj-$(CONFIG_USB_CHIPIDEA)	+= ci_hdrc_usb2.o
> > > 
> > > usb2 is too generic, you should call it ci_hdcr_marvell, or something
> > > like that.
> > 
> > This driver is generic, and not only for Marvell Berlin SoCs. It is part
> > of the Berlin USB series as it is the first SoC to use it but Xilinx can
> > also use it for example.
> 
> then how about ci_hdrc_generic.c ?

We had this discussion during in the v2 thread of this series[1]. I tend
to prefer not using the 'generic' keyword. I think using 'usb2' is
generic enough here.


Antoine

[1] https://lkml.org/lkml/2014/6/24/197

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
