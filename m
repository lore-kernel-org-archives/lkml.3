Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3CEOYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:24:54 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39767 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab3CEOYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:24:52 -0500
Message-ID: <51360020.4050503@ti.com>
Date: Tue, 5 Mar 2013 19:54:32 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, <arm@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Latest randconfig build errors
References: <20130304095136.GI17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130304095136.GI17833@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/2013 3:21 PM, Russell King - ARM Linux wrote:
> Last nights automated ARM build found the following errors with randconfig.
> 
> All information as usual at http://www.arm.linux.org.uk/developer/build/
> 
> 
> Versatile randconfig:
> 
> ERROR: "irq_domain_add_simple" [drivers/gpio/gpio-em.ko] undefined!
> 
> OMAP4430 randconfig:

> The last three are caused by incorrect use of 'select':
> 
> warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3 && MWAVE) selects SERIAL_8250 which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)
> warning: (USB_MUSB_HDRC) selects TWL4030_USB which has unmet direct dependencies (USB_SUPPORT && (USB || USB_GADGET) && TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS)
> warning: (USB_MUSB_HDRC) selects TWL6030_USB which has unmet direct dependencies (USB_SUPPORT && (USB || USB_GADGET) && TWL4030_CORE && OMAP_USB2 && USB_MUSB_OMAP2PLUS)
> warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3) selects SERIAL_8250_CONSOLE which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS && SERIAL_8250=y)
> warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3) selects SERIAL_CORE_CONSOLE which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)
> warning: (VIDEO_DM6446_CCDC && VIDEO_DM355_CCDC && VIDEO_ISIF && VIDEO_DAVINCI_VPBE_DISPLAY) selects VIDEO_VPSS_SYSTEM which has unmet direct dependencies (MEDIA_SUPPORT && V4L_PLATFORM_DRIVERS && ARCH_DAVINCI)
> warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3 && MWAVE) selects SERIAL_8250 which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)
> warning: (USB_MUSB_HDRC) selects TWL4030_USB which has unmet direct dependencies (USB_SUPPORT && (USB || USB_GADGET) && TWL4030_CORE && OMAP_USB2 && USB_MUSB_OMAP2PLUS)
> warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3) selects SERIAL_8250_CONSOLE which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS && SERIAL_8250=y)
> warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3) selects SERIAL_CORE_CONSOLE which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)
> warning: (VIDEO_DM6446_CCDC && VIDEO_DM355_CCDC && VIDEO_ISIF && VIDEO_DAVINCI_VPBE_DISPLAY) selects VIDEO_VPSS_SYSTEM which has unmet direct dependencies (MEDIA_SUPPORT && V4L_PLATFORM_DRIVERS && ARCH_DAVINCI)

I submitted a patch to the media guys for the DaVinci media driver
related issues.

http://linux.davincidsp.com/pipermail/davinci-linux-open-source/2013-March/026559.html

Thanks,
Sekhar
