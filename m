Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab3CDSyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:54:32 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:34736 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758118Ab3CDSy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:54:29 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18bRLdYTSL3i4X2OvzR8+QM
Date: Mon, 4 Mar 2013 10:54:24 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Latest randconfig build errors
Message-ID: <20130304185424.GR11806@atomide.com>
References: <20130304095136.GI17833@n2100.arm.linux.org.uk>
 <20130304184649.GO11806@atomide.com>
 <20130304185142.GB15203@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304185142.GB15203@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [130304 10:56]:
> Hi,
> 
> On Mon, Mar 04, 2013 at 10:46:50AM -0800, Tony Lindgren wrote:
> > > The last three are caused by incorrect use of 'select':
> > > 
> > > warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3 && MWAVE) selects SERIAL_8250 which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)
> > > warning: (USB_MUSB_HDRC) selects TWL4030_USB which has unmet direct dependencies (USB_SUPPORT && (USB || USB_GADGET) && TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS)
> > > warning: (USB_MUSB_HDRC) selects TWL6030_USB which has unmet direct dependencies (USB_SUPPORT && (USB || USB_GADGET) && TWL4030_CORE && OMAP_USB2 && USB_MUSB_OMAP2PLUS)
> > > warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3) selects SERIAL_8250_CONSOLE which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS && SERIAL_8250=y)
> > > warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3) selects SERIAL_CORE_CONSOLE which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)
> > > warning: (VIDEO_DM6446_CCDC && VIDEO_DM355_CCDC && VIDEO_ISIF && VIDEO_DAVINCI_VPBE_DISPLAY) selects VIDEO_VPSS_SYSTEM which has unmet direct dependencies (MEDIA_SUPPORT && V4L_PLATFORM_DRIVERS && ARCH_DAVINCI)
> > > warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3 && MWAVE) selects SERIAL_8250 which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)
> > > warning: (USB_MUSB_HDRC) selects TWL4030_USB which has unmet direct dependencies (USB_SUPPORT && (USB || USB_GADGET) && TWL4030_CORE && OMAP_USB2 && USB_MUSB_OMAP2PLUS)
> > > warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3) selects SERIAL_8250_CONSOLE which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS && SERIAL_8250=y)
> > > warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3) selects SERIAL_CORE_CONSOLE which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)
> > > warning: (VIDEO_DM6446_CCDC && VIDEO_DM355_CCDC && VIDEO_ISIF && VIDEO_DAVINCI_VPBE_DISPLAY) selects VIDEO_VPSS_SYSTEM which has unmet direct dependencies (MEDIA_SUPPORT && V4L_PLATFORM_DRIVERS && ARCH_DAVINCI)
> > > 
> > > This 'select' madness of driver symbols *HAS* *TO* *STOP*.
> > 
> > Felipe, can you take a look at removing the MUSB selects from Kconfig?
> > You might be able to just have MUSB depends on TWL if omap.
> 
> I don't think we even need depend or select at all for MUSB. I'll look
> at it tomorrow.

OK thanks!

Tony
