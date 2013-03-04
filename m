Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3CDJxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:53:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53443 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab3CDJxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:53:04 -0500
Date: Mon, 4 Mar 2013 09:51:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Latest randconfig build errors
Message-ID: <20130304095136.GI17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last nights automated ARM build found the following errors with randconfig.

All information as usual at http://www.arm.linux.org.uk/developer/build/


Versatile randconfig:

ERROR: "irq_domain_add_simple" [drivers/gpio/gpio-em.ko] undefined!

OMAP4430 randconfig:

drivers/gpu/drm/tilcdc/tilcdc_slave.o:(.data+0x54): multiple definition of `__mod_of_device_table'
drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
drivers/gpu/drm/tilcdc/tilcdc_panel.o:(.data+0x54): multiple definition of `__mod_of_device_table'
drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
drivers/gpu/drm/tilcdc/tilcdc_drv.o:(.data+0x184): multiple definition of `__mod_of_device_table'
drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
drivers/tty/serial/8250/8250.c:57:32: error: 'CONFIG_SERIAL_8250_RUNTIME_UARTS' undeclared here (not in a function)
drivers/tty/serial/8250/8250.c:2712:47: error: 'CONFIG_SERIAL_8250_NR_UARTS' undeclared here (not in a function)
drivers/tty/serial/8250/8250.c:2971:95: error: negative width in bit-field '<anonymous>' 

The last three are caused by incorrect use of 'select':

warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3 && MWAVE) selects SERIAL_8250 which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)
warning: (USB_MUSB_HDRC) selects TWL4030_USB which has unmet direct dependencies (USB_SUPPORT && (USB || USB_GADGET) && TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS)
warning: (USB_MUSB_HDRC) selects TWL6030_USB which has unmet direct dependencies (USB_SUPPORT && (USB || USB_GADGET) && TWL4030_CORE && OMAP_USB2 && USB_MUSB_OMAP2PLUS)
warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3) selects SERIAL_8250_CONSOLE which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS && SERIAL_8250=y)
warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3) selects SERIAL_CORE_CONSOLE which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)
warning: (VIDEO_DM6446_CCDC && VIDEO_DM355_CCDC && VIDEO_ISIF && VIDEO_DAVINCI_VPBE_DISPLAY) selects VIDEO_VPSS_SYSTEM which has unmet direct dependencies (MEDIA_SUPPORT && V4L_PLATFORM_DRIVERS && ARCH_DAVINCI)
warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3 && MWAVE) selects SERIAL_8250 which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)
warning: (USB_MUSB_HDRC) selects TWL4030_USB which has unmet direct dependencies (USB_SUPPORT && (USB || USB_GADGET) && TWL4030_CORE && OMAP_USB2 && USB_MUSB_OMAP2PLUS)
warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3) selects SERIAL_8250_CONSOLE which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS && SERIAL_8250=y)
warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3) selects SERIAL_CORE_CONSOLE which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)
warning: (VIDEO_DM6446_CCDC && VIDEO_DM355_CCDC && VIDEO_ISIF && VIDEO_DAVINCI_VPBE_DISPLAY) selects VIDEO_VPSS_SYSTEM which has unmet direct dependencies (MEDIA_SUPPORT && V4L_PLATFORM_DRIVERS && ARCH_DAVINCI)

This 'select' madness of driver symbols *HAS* *TO* *STOP*.
