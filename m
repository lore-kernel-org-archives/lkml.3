Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaILPuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:50:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59449 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaILPuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:50:02 -0400
X-AuditID: cbfee61b-f79f86d00000144c-2c-54131627cab1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dinguyen@opensource.altera.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, balbi@ti.com,
        dinh.linux@gmail.com, swarren@wwwdotorg.org, matthijs@stdin.nl,
        r.baldyga@samsung.com, jg1.han@samsung.com, sachin.kamat@linaro.org,
        ben-linux@fluff.org, dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 01/12] usb: dwc2: Update Kconfig to support dual-role
Date: Fri, 12 Sep 2014 17:49:56 +0200
Message-id: <2539965.N1OFkvgc6j@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1409070003-21195-2-git-send-email-dinguyen@opensource.altera.com>
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
 <1409070003-21195-2-git-send-email-dinguyen@opensource.altera.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t9jAV11MeEQg/eTjCwO3q+3mLTuAJPF
	2WUH2SxWfVrDbLHypLZF8+L1bBaXF15itdg2/SeQtWsOm8WiZa3MFgtfX2Ox2D5lOpPFg8M7
	2S1O/ulltHh1sI3Fgd9jdsNFFo+/q14we+ycdZfd4861PWwe++euYffovzaJ3ePvrP0sHn1b
	VjF6fPnxj8Vjy/7PjB7Hb2xn8vi8Sc5j49zQAN4oLpuU1JzMstQifbsErowtU30K5ltVzGq5
	wdrA2KnXxcjJISFgIvHr5TF2CFtM4sK99WxdjFwcQgKLGCVOzz3ODOG0MEm8bP7NClLFJmAl
	MbF9FSOILSKgJNG76iULSBGzwFkmiRW71jKDJIQFvCWm3HrOBmKzCKhKbD15DmgFBwevgKbE
	q3veIGFRAU+JHdtXgpVwCvhLTD1wmxVi2WRGiZezzzOBJHgFBCV+TL7HAmIzC8hL7Ns/lRXC
	1pHY3zqNbQKjwCwkZbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAEPpPe
	wbiqweIQowAHoxIPbyWLYIgQa2JZcWXuIUYJDmYlEd4br4RChHhTEiurUovy44tKc1KLDzFK
	c7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTCuj301+8EzZ1WNN1MqH3z4lPXn7waBZdxH
	pUuWhR0LMWD03m+3+IXfge8cTzdvyMr+y89+7qnh+0ep1WfUXwg0nzz+UShI8POsQsPadSs0
	O9e9Tvx0htUp4t7BFJO5D3Svna922qpYbakylaGI6SL3t3QfqQcHGNjDsh/LTZz7kY07Ytd3
	Mee5SizFGYmGWsxFxYkAmjLo6rwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-kernel ML to cc: ]

Hi,

On Tuesday, August 26, 2014 11:19:52 AM dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Update DWC2 kconfig and makefile to support dual-role mode. The platform
> file will always get compiled for the case where the controller is directly
> connected to the CPU. So for loadable modules, only dwc2.ko is needed.

Kconfig and Makefile changes should be done after (or at the same time as)
driver code itself is modified to support dual-role mode.  Each individual
patch of the patchset should be correct itself (not cause any breakages)
in order to keep the whole patchset bisectable.

> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
> v3: Add USB_GADGET=y and USB_GADGET=USB_DWC2 for peripheral and dual-role
>     config options.
> v2: Remove reference to dwc2_gadget
> ---
>  drivers/usb/dwc2/Kconfig  | 63 +++++++++++++++++++++++++++--------------------
>  drivers/usb/dwc2/Makefile | 21 ++++++++--------
>  2 files changed, 47 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/Kconfig b/drivers/usb/dwc2/Kconfig
> index f93807b..4396a1f 100644
> --- a/drivers/usb/dwc2/Kconfig
> +++ b/drivers/usb/dwc2/Kconfig
> @@ -1,40 +1,29 @@
>  config USB_DWC2
> -	bool "DesignWare USB2 DRD Core Support"
> +	tristate "DesignWare USB2 DRD Core Support"
>  	depends on USB
>  	help
>  	  Say Y here if your system has a Dual Role Hi-Speed USB
>  	  controller based on the DesignWare HSOTG IP Core.
>  
> -	  For host mode, if you choose to build the driver as dynamically
> -	  linked modules, the core module will be called dwc2.ko, the PCI
> -	  bus interface module (if you have a PCI bus system) will be
> -	  called dwc2_pci.ko, and the platform interface module (for
> -	  controllers directly connected to the CPU) will be called
> -	  dwc2_platform.ko. For gadget mode, there will be a single
> -	  module called dwc2_gadget.ko.
> -
> -	  NOTE: The s3c-hsotg driver is now renamed to dwc2_gadget. The
> -	  host and gadget drivers are still currently separate drivers.
> -	  There are plans to merge the dwc2_gadget driver with the dwc2
> -	  host driver in the near future to create a dual-role driver.
> +	  If you choose to build the driver as dynamically
> +	  linked modules, a single dwc2.ko(regardless of mode of operation)

minort nitpick: " " is missing after dwc2.ko

> +	  will get built for both platform IPs and PCI.

Why do you want ot merge both platform and PCI drivers into one?

To do it properly you need to modify module_init/exit() of the final
module to properly handle both PCI and platform devices.  It should
be easier to leave separate dwc2_pci/platform drivers and just put
the common code into dwc2.ko.

>  if USB_DWC2
>  
> +choice
> +	bool "DWC2 Mode Selection"
> +	default USB_DWC2_DUAL_ROLE if (USB && USB_GADGET)
> +	default USB_DWC2_HOST if (USB && !USB_GADGET)
> +	default USB_DWC2_PERIPHERAL if (!USB && USB_GADGET)
> +
>  config USB_DWC2_HOST
> -	tristate "Host only mode"
> +	bool "Host only mode"
>  	depends on USB
>  	help
>  	  The Designware USB2.0 high-speed host controller
> -	  integrated into many SoCs.
> -
> -config USB_DWC2_PLATFORM
> -	bool "DWC2 Platform"
> -	depends on USB_DWC2_HOST
> -	default USB_DWC2_HOST
> -	help
> -	  The Designware USB2.0 platform interface module for
> -	  controllers directly connected to the CPU. This is only
> -	  used for host mode.
> +	  integrated into many SoCs. Select this option if you want the
> +	  driver to operate in Host-only mode.
>  
>  config USB_DWC2_PCI
>  	bool "DWC2 PCI"

Why have you left this option into middle of 'choice' selection?

You've also left the "depends on USB_DWC2_HOST && PCI" unmodified
which causes DWC2 PCI support to show up only if "Host only mode"
is selected (it is not available if "Dual Role mode" is selected).

> @@ -47,11 +36,31 @@ config USB_DWC2_PCI
>  comment "Gadget mode requires USB Gadget support to be enabled"
>  
>  config USB_DWC2_PERIPHERAL
> -	tristate "Gadget only mode"
> -	depends on USB_GADGET
> +	bool "Gadget only mode"
> +	depends on USB_GADGET=y || USB_GADGET=USB_DWC2
>  	help
>  	  The Designware USB2.0 high-speed gadget controller
> -	  integrated into many SoCs.
> +	  integrated into many SoCs. Select this option if you want the
> +	  driver to operate in Peripheral-only mode. This option requires
> +	  USB_GADGET=y.
> +
> +config USB_DWC2_DUAL_ROLE
> +	bool "Dual Role mode"
> +	depends on ((USB=y || USB=USB_DWC2) && (USB_GADGET=y || USB_GADGET=USB_DWC2))

I believe that extra parentheses are not needed.

> +	help
> +	  Select this option if you want the driver to work in a dual-role
> +	  mode. In this mode both host and gadget features are enabled, and
> +	  the role will be determined by the cable that gets plugged-in. This
> +	  option requires USB_GADGET=y.
> +endchoice
> +
> +config USB_DWC2_PLATFORM
> +	bool
> +        depends on !PCI

Why have you introduced this limitation (without even mentioning it in
the patch description)?  I suspect that by this change and disabling
PCI in your config you've workarounded the issue of having the common
module for PCI and platform parts completely.  Sorry but this is
incorrect as we want to have PCI and platform support in one compiled
kernel.

> +        default y
> +        help
> +          The Designware USB2.0 platform interface module for
> +          controllers directly connected to the CPU.
>  
>  config USB_DWC2_DEBUG
>  	bool "Enable Debugging Messages"
> diff --git a/drivers/usb/dwc2/Makefile b/drivers/usb/dwc2/Makefile
> index b73d2a5..3026135 100644
> --- a/drivers/usb/dwc2/Makefile
> +++ b/drivers/usb/dwc2/Makefile
> @@ -1,10 +1,17 @@
>  ccflags-$(CONFIG_USB_DWC2_DEBUG)	+= -DDEBUG
>  ccflags-$(CONFIG_USB_DWC2_VERBOSE)	+= -DVERBOSE_DEBUG
>  
> -obj-$(CONFIG_USB_DWC2_HOST)		+= dwc2.o
> +obj-$(CONFIG_USB_DWC2)			+= dwc2.o
>  dwc2-y					:= core.o core_intr.o
> -dwc2-y					+= hcd.o hcd_intr.o
> -dwc2-y					+= hcd_queue.o hcd_ddma.o
> +
> +ifneq ($(filter y,$(CONFIG_USB_DWC2_HOST) $(CONFIG_USB_DWC2_DUAL_ROLE)),)
> +	dwc2-y				+= hcd.o hcd_intr.o
> +	dwc2-y				+= hcd_queue.o hcd_ddma.o
> +endif
> +
> +ifneq ($(filter y,$(CONFIG_USB_DWC2_PERIPHERAL) $(CONFIG_USB_DWC2_DUAL_ROLE)),)
> +	dwc2-y       			+= gadget.o
> +endif
>  
>  # NOTE: The previous s3c-hsotg peripheral mode only driver has been moved to
>  # this location and renamed gadget.c. When building for dynamically linked

This comment is no longer true after your changes.

> @@ -19,10 +26,4 @@ ifneq ($(CONFIG_USB_DWC2_PCI),)
>  	dwc2_pci-y			:= pci.o
>  endif

dwc2_pci will still be build as separate module despite what the updated
documentation for USB_DWC2 says.

> -ifneq ($(CONFIG_USB_DWC2_PLATFORM),)
> -	obj-$(CONFIG_USB_DWC2_HOST)	+= dwc2_platform.o
> -	dwc2_platform-y			:= platform.o
> -endif
> -
> -obj-$(CONFIG_USB_DWC2_PERIPHERAL)	+= dwc2_gadget.o
> -dwc2_gadget-y				:= gadget.o
> +dwc2-$(CONFIG_USB_DWC2_PLATFORM) += platform.o

platform.c references code from hcd.c but will be built alone for
USB_DWC2_PERIPHERAL=y config (the link failure will happen).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

