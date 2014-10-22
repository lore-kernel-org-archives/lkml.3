Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933431AbaJVM01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:26:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26146 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865AbaJVM00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:26:26 -0400
X-AuditID: cbfee61b-f79d76d0000024d6-04-5447a26f3b07
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dinguyen@opensource.altera.com
Cc: paulz@synopsys.com, balbi@ti.com, dinh.linux@gmail.com,
        linux-kernel@vger.kernel.org, swarren@wwwdotorg.org, matthijs@stdin.nl,
        r.baldyga@samsung.com, jg1.han@samsung.com, sachin.kamat@linaro.org,
        ben-linux@fluff.org, dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org
Subject: Re: [PATCHv5 7/7] usb: dwc2: Update Kconfig to support dual-role
Date: Wed, 22 Oct 2014 14:25:46 +0200
Message-id: <9429092.fliZzSsbVp@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
 <1413831126-24193-8-git-send-email-dinguyen@opensource.altera.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jQd38Re4hBp+fG1scvF9vMWndASaL
	s8sOslms+rSG2WLlSW2LywsvsVpsm/6TzeLyrjlsFouWtTJbLHx9jcVi+5TpTBYPDu9ktzj5
	p5fR4tXBNhYHPo/ZDRdZPP6uesHssXPWXXaPO9f2sHn0X5vE7vF31n4Wj74tqxg9vvz4x+Kx
	Zf9nRo/jN7YzeXzeJOexcW5oAE8Ul01Kak5mWWqRvl0CV8av/YdZCx5bVlzvvMPSwNii18XI
	ySEhYCKxeecDRghbTOLCvfVsXYxcHEIC0xklWh4+YIZwWpgk1h5qYgOpYhOwkpjYvgqsQ0RA
	SaJ31UsWEJtZYCOTxPtvFiC2sICnRPOf3cwgNouAqkTfou1MIDavgKbE8ZNbWEFsUaCaHdtX
	gs3kFPCX2HbhCNTmyYwS+5peMkM0CEr8mHwPaoG8xL79U1khbB2J/a3T2CYwCsxCUjYLSdks
	JGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTH2zPpHYyrGiwOMQpwMCrx8DqwuYcI
	sSaWFVfmHmKU4GBWEuFVqgcK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpa
	kFoEk2Xi4JRqYGy272Sqn39U5t3nT3s9BefOWrTwieGd7otsnbO0chZYrXta0hbDwdLcrPUt
	1HOlev0zztXec46JHy/kkJ9zWEM7f/srbZH6T0WZXHrW7m/zc0pVHgc9Mmb4K7uqNpNz4gvD
	ZQFTE7RNA9k0FUxLfh+2PnyjSfvoUY9dLz9YrMl9Hqa37EUYoxJLcUaioRZzUXEiAGhx0+Sz	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, October 20, 2014 01:52:06 PM dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Update DWC2 kconfig and makefile to support dual-role mode. The platform
> file will always get compiled for the case where the controller is directly
> connected to the CPU. So for loadable modules, dwc2.ko is built for host,
> peripheral, and dual-role mode. The PCI bus interface will be called
> dwc2_pci.ko and the platform interface module will be called dwc2_platform.ko.
> 
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
> v5: dwc2.ko for all modes along with dwc2_platform.ko and dwc2_pci.ko will
>     get built for kernel modules.
> v3: Add USB_GADGET=y and USB_GADGET=USB_DWC2 for peripheral and dual-role
>     config options.
> v2: Remove reference to dwc2_gadget
> ---
>  drivers/usb/dwc2/Kconfig  | 61 ++++++++++++++++++++++++++++-------------------
>  drivers/usb/dwc2/Makefile | 32 ++++++++++++-------------
>  2 files changed, 53 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/Kconfig b/drivers/usb/dwc2/Kconfig
> index f93807b..1ea702e 100644
> --- a/drivers/usb/dwc2/Kconfig
> +++ b/drivers/usb/dwc2/Kconfig
> @@ -1,5 +1,5 @@
>  config USB_DWC2
> -	bool "DesignWare USB2 DRD Core Support"
> +	tristate "DesignWare USB2 DRD Core Support"
>  	depends on USB
>  	help
>  	  Say Y here if your system has a Dual Role Hi-Speed USB
> @@ -10,31 +10,53 @@ config USB_DWC2
>  	  bus interface module (if you have a PCI bus system) will be
>  	  called dwc2_pci.ko, and the platform interface module (for
>  	  controllers directly connected to the CPU) will be called
> -	  dwc2_platform.ko. For gadget mode, there will be a single
> -	  module called dwc2_gadget.ko.
> -
> -	  NOTE: The s3c-hsotg driver is now renamed to dwc2_gadget. The
> -	  host and gadget drivers are still currently separate drivers.
> -	  There are plans to merge the dwc2_gadget driver with the dwc2
> -	  host driver in the near future to create a dual-role driver.
> +	  dwc2_platform.ko. For all modes(host, gadget and dual-role), there
> +	  will be a single module called dwc2.ko.
>  
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
> +	  integrated into many SoCs. Select this option if you want the
> +	  driver to operate in Host-only mode.
> +
> +comment "Gadget/Dual-role mode requires USB Gadget support to be enabled"
> +
> +config USB_DWC2_PERIPHERAL
> +	bool "Gadget only mode"
> +	depends on USB_GADGET=y || USB_GADGET=USB_DWC2
> +	help
> +	  The Designware USB2.0 high-speed gadget controller
> +	  integrated into many SoCs. Select this option if you want the
> +	  driver to operate in Peripheral-only mode. This option requires
> +	  USB_GADGET=y.
> +
> +config USB_DWC2_DUAL_ROLE
> +	bool "Dual Role mode"
> +	depends on (USB=y || USB=USB_DWC2) && (USB_GADGET=y || USB_GADGET=USB_DWC2)
> +	help
> +	  Select this option if you want the driver to work in a dual-role
> +	  mode. In this mode both host and gadget features are enabled, and
> +	  the role will be determined by the cable that gets plugged-in. This
> +	  option requires USB_GADGET=y.
> +endchoice
>  
>  config USB_DWC2_PLATFORM
>  	bool "DWC2 Platform"
> -	depends on USB_DWC2_HOST
>  	default USB_DWC2_HOST

It should be "default USB_DWC2_HOST || USB_DWC2_PERIPHERAL" because
USB_DWC2_PLATFORM replaces current USB_DWC2_PERIPHERAL functionality.

Additionaly USB_DWC2_PLATFORM should be changed to tristate
(USB_DWC2_PERIPHERAL was a tristeate before your changes).

BTW It is a bit late but it would be great if you could split your
patchset on two.  First one merging gadget functionality into
core/platform code and the second one adding USB_DWC2_DUAL_ROLE
functionality.

> -	help
> -	  The Designware USB2.0 platform interface module for
> -	  controllers directly connected to the CPU. This is only
> -	  used for host mode.
> +        default y
> +        help
> +          The Designware USB2.0 platform interface module for
> +          controllers directly connected to the CPU.
>  
>  config USB_DWC2_PCI
>  	bool "DWC2 PCI"
> @@ -44,15 +66,6 @@ config USB_DWC2_PCI
>  	  The Designware USB2.0 PCI interface module for controllers
>  	  connected to a PCI bus. This is only used for host mode.
>  
> -comment "Gadget mode requires USB Gadget support to be enabled"
> -
> -config USB_DWC2_PERIPHERAL
> -	tristate "Gadget only mode"
> -	depends on USB_GADGET
> -	help
> -	  The Designware USB2.0 high-speed gadget controller
> -	  integrated into many SoCs.
> -
>  config USB_DWC2_DEBUG
>  	bool "Enable Debugging Messages"
>  	help
> diff --git a/drivers/usb/dwc2/Makefile b/drivers/usb/dwc2/Makefile
> index b73d2a5..2175d93 100644
> --- a/drivers/usb/dwc2/Makefile
> +++ b/drivers/usb/dwc2/Makefile
> @@ -1,28 +1,28 @@
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
> -# modules, dwc2_gadget.ko will get built for peripheral mode. For host mode,
> -# the core module will be dwc2.ko, the PCI bus interface module will called
> -# dwc2_pci.ko and the platform interface module will be called dwc2_platform.ko.
> -# At present the host and gadget driver will be separate drivers, but there
> -# are plans in the near future to create a dual-role driver.
> +# modules, dwc2.ko will get built for host mode, peripheral mode, and dual-role
> +# mode. The PCI bus interface module will called dwc2_pci.ko and the platform
> +# interface module will be called dwc2_platform.ko.
>  
>  ifneq ($(CONFIG_USB_DWC2_PCI),)
> -	obj-$(CONFIG_USB_DWC2_HOST)	+= dwc2_pci.o
> +	obj-$(CONFIG_USB_DWC2)		+= dwc2_pci.o
>  	dwc2_pci-y			:= pci.o
>  endif
>  
> -ifneq ($(CONFIG_USB_DWC2_PLATFORM),)
> -	obj-$(CONFIG_USB_DWC2_HOST)	+= dwc2_platform.o
> -	dwc2_platform-y			:= platform.o
> -endif
> -
> -obj-$(CONFIG_USB_DWC2_PERIPHERAL)	+= dwc2_gadget.o
> -dwc2_gadget-y				:= gadget.o
> +obj-$(CONFIG_USB_DWC2)			+= dwc2_platform.o

Shouldn't it use CONFIG_USB_DWC2_PLATFORM instead of CONFIG_USB_DWC2?

> +dwc2_platform-y				:= platform.o
 
Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

