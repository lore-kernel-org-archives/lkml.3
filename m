Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab3CDSrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:47:00 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:17058 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756790Ab3CDSq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:46:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19MxtTIJDeV/x+Rki/kQpbr
Date: Mon, 4 Mar 2013 10:46:50 -0800
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Clark <robdclark@gmail.com>, Felipe Balbi <balbi@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        arm@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Latest randconfig build errors
Message-ID: <20130304184649.GO11806@atomide.com>
References: <20130304095136.GI17833@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304095136.GI17833@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob & Felipe,

* Russell King - ARM Linux <linux@arm.linux.org.uk> [130304 01:56]:
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
> 
> drivers/gpu/drm/tilcdc/tilcdc_slave.o:(.data+0x54): multiple definition of `__mod_of_device_table'
> drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
> drivers/gpu/drm/tilcdc/tilcdc_panel.o:(.data+0x54): multiple definition of `__mod_of_device_table'
> drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
> drivers/gpu/drm/tilcdc/tilcdc_drv.o:(.data+0x184): multiple definition of `__mod_of_device_table'
> drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here

Rob, I assume you'll do a patch for this one?

> drivers/tty/serial/8250/8250.c:57:32: error: 'CONFIG_SERIAL_8250_RUNTIME_UARTS' undeclared here (not in a function)
> drivers/tty/serial/8250/8250.c:2712:47: error: 'CONFIG_SERIAL_8250_NR_UARTS' undeclared here (not in a function)
> drivers/tty/serial/8250/8250.c:2971:95: error: negative width in bit-field '<anonymous>' 

The patch below fixes the 8250 related issue by removing the
selects from Kconfig and adding them to omap2plus_defconfig.
 
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
> 
> This 'select' madness of driver symbols *HAS* *TO* *STOP*.

Felipe, can you take a look at removing the MUSB selects from Kconfig?
You might be able to just have MUSB depends on TWL if omap.

Regards,

Tony


From: Tony Lindgren <tony@atomide.com>
Date: Mon, 4 Mar 2013 10:28:21 -0800
Subject: [PATCH] ARM: OMAP2+: Fix unmet direct dependencies for zoom for 8250 serial

We should not select drivers from kconfig as they should by default
be optional. Otherwise we'll be chasing broken dependencies forever:

warning: (MACH_OMAP_ZOOM2 && MACH_OMAP_ZOOM3 && MWAVE) selects SERIAL_8250
which has unmet direct dependencies (TTY && HAS_IOMEM && GENERIC_HARDIRQS)

Fix the issue by removing the selects for zoom and add them to
omap2plus_defconfig.

Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -126,6 +126,8 @@ CONFIG_INPUT_MISC=y
 CONFIG_INPUT_TWL4030_PWRBUTTON=y
 CONFIG_VT_HW_CONSOLE_BINDING=y
 # CONFIG_LEGACY_PTYS is not set
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_8250_NR_UARTS=32
 CONFIG_SERIAL_8250_EXTENDED=y
 CONFIG_SERIAL_8250_MANY_PORTS=y
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -311,9 +311,6 @@ config MACH_OMAP_ZOOM2
 	default y
 	select OMAP_PACKAGE_CBB
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
-	select SERIAL_8250
-	select SERIAL_8250_CONSOLE
-	select SERIAL_CORE_CONSOLE
 
 config MACH_OMAP_ZOOM3
 	bool "OMAP3630 Zoom3 board"
@@ -321,9 +318,6 @@ config MACH_OMAP_ZOOM3
 	default y
 	select OMAP_PACKAGE_CBP
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
-	select SERIAL_8250
-	select SERIAL_8250_CONSOLE
-	select SERIAL_CORE_CONSOLE
 
 config MACH_CM_T35
 	bool "CompuLab CM-T35/CM-T3730 modules"
