Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935691Ab3DJGm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:42:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:8922 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab3DJGm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:42:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,444,1363158000"; 
   d="scan'208";a="225396069"
Date: Wed, 10 Apr 2013 08:42:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Smirnov <andrew.smirnov@gmail.com>
Subject: Re: linux-next: manual merge of the mfd tree with the v4l-dvb tree
Message-ID: <20130410064253.GA4874@zurbaran>
References: <20130410134813.b1bff6027f64f14d75d43927@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410134813.b1bff6027f64f14d75d43927@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Apr 10, 2013 at 01:48:13PM +1000, Stephen Rothwell wrote:
> Hi Samuel,
> 
> Today's linux-next merge of the mfd tree got a conflict in
> drivers/mfd/Kconfig between commit 3f8ec5df11aa ("[media] mfd: Add header
> files and Kbuild plumbing for SI476x MFD core") from the v4l-dvb tree and
> commit ab85b120e692 ("mfd: Kconfig alphabetical re-ordering") from the
> mfd tree.
I'm surprised the v4l-dvb tree is carrying this patchset because I haven't
ACKed it. I was planning to take the MFD bits of it and provide Mauro a branch
to pull from (Including the mfd/Kconfig change).
Mauro, could we please go that way instead ? This conflict does not look
pretty to me.

Cheers,
Samuel.


> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).
> 
> diff --cc drivers/mfd/Kconfig
> index b6bb6d5,2f3ce18..0000000
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@@ -977,68 -920,38 +920,51 @@@ config MFD_WL1273_COR
>   	  driver connects the radio-wl1273 V4L2 module and the wl1273
>   	  audio codec.
>   
>  +config MFD_SI476X_CORE
>  +	tristate "Support for Silicon Laboratories 4761/64/68 AM/FM radio."
>  +	depends on I2C
>  +	select MFD_CORE
>  +	select REGMAP_I2C
>  +	help
>  +	  This is the core driver for the SI476x series of AM/FM
>  +	  radio. This MFD driver connects the radio-si476x V4L2 module
>  +	  and the si476x audio codec.
>  +
>  +	  To compile this driver as a module, choose M here: the
>  +	  module will be called si476x-core.
>  +
> - config MFD_OMAP_USB_HOST
> - 	bool "Support OMAP USBHS core and TLL driver"
> - 	depends on USB_EHCI_HCD_OMAP || USB_OHCI_HCD_OMAP3
> - 	default y
> - 	help
> - 	  This is the core driver for the OAMP EHCI and OHCI drivers.
> - 	  This MFD driver does the required setup functionalities for
> - 	  OMAP USB Host drivers.
> - 
> - config MFD_PM8XXX
> - 	tristate
> - 
> - config MFD_PM8921_CORE
> - 	tristate "Qualcomm PM8921 PMIC chip"
> - 	depends on MSM_SSBI
> + config MFD_LM3533
> + 	tristate "TI/National Semiconductor LM3533 Lighting Power chip"
> + 	depends on I2C
>   	select MFD_CORE
> - 	select MFD_PM8XXX
> + 	select REGMAP_I2C
> + 	depends on GENERIC_HARDIRQS
>   	help
> - 	  If you say yes to this option, support will be included for the
> - 	  built-in PM8921 PMIC chip.
> - 
> - 	  This is required if your board has a PM8921 and uses its features,
> - 	  such as: MPPs, GPIOs, regulators, interrupts, and PWM.
> - 
> - 	  Say M here if you want to include support for PM8921 chip as a module.
> - 	  This will build a module called "pm8921-core".
> + 	  Say yes here to enable support for National Semiconductor / TI
> + 	  LM3533 Lighting Power chips.
>   
> - config MFD_PM8XXX_IRQ
> - 	bool "Support for Qualcomm PM8xxx IRQ features"
> - 	depends on MFD_PM8XXX
> - 	default y if MFD_PM8XXX
> - 	help
> - 	  This is the IRQ driver for Qualcomm PM 8xxx PMIC chips.
> + 	  This driver provides common support for accessing the device;
> + 	  additional drivers must be enabled in order to use the LED,
> + 	  backlight or ambient-light-sensor functionality of the device.
>   
> - 	  This is required to use certain other PM 8xxx features, such as GPIO
> - 	  and MPP.
> + config MFD_TIMBERDALE
> + 	tristate "Timberdale FPGA"
> + 	select MFD_CORE
> + 	depends on PCI && GPIOLIB
> + 	---help---
> + 	This is the core driver for the timberdale FPGA. This device is a
> + 	multifunction device which exposes numerous platform devices.
>   
> - config TPS65911_COMPARATOR
> - 	tristate
> + 	The timberdale FPGA can be found on the Intel Atom development board
> + 	for in-vehicle infontainment, called Russellville.
>   
> - config MFD_TPS65090
> - 	bool "TPS65090 Power Management chips"
> + config MFD_TC3589X
> + 	bool "Toshiba TC35892 and variants"
>   	depends on I2C=y && GENERIC_HARDIRQS
>   	select MFD_CORE
> - 	select REGMAP_I2C
> - 	select REGMAP_IRQ
>   	help
> - 	  If you say yes here you get support for the TPS65090 series of
> - 	  Power Management chips.
> + 	  Support for the Toshiba TC35892 and variants I/O Expander.
> + 
>   	  This driver provides common support for accessing the device,
>   	  additional drivers must be enabled in order to use the
>   	  functionality of the device.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



-- 
Intel Open Source Technology Centre
http://oss.intel.com/
