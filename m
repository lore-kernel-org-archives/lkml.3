Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbbAETw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:52:57 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57821 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528AbbAETwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:52:54 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2015 14:52:54 EST
X-Sasl-enc: S/0Qd2MLisBOqfgUglMvOA7cC0KfgbPqNHnhpPpnKcZg 1420486985
Date: Mon, 5 Jan 2015 14:43:05 -0500
From: Christoph Jaeger <cj@linux.com>
To: yann.morin.1998@free.fr, akpm@linux-foundation.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dborkman@redhat.com, pebolle@tiscali.nl, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] kconfig: use bool instead of boolean for type definition
 attributes
Message-ID: <20150105194305.GB1513@betelgeuse.hsd1.ma.comcast.net>
References: <1419108071-11607-1-git-send-email-cj@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419108071-11607-1-git-send-email-cj@linux.com>
X-Homepage: http://christophjaeger.info
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Michal Marek)

On Sat, Dec 20, 2014 at 03:41:11PM -0500, Christoph Jaeger wrote:
> Support for keyword 'boolean' will be dropped later on.
> 
> No functional change.
> 
> Reference: http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com
> Signed-off-by: Christoph Jaeger <cj@linux.com>
> ---
>  arch/mips/pmcs-msp71xx/Kconfig      |  6 +++---
>  drivers/connector/Kconfig           |  2 +-
>  drivers/hwmon/Kconfig               |  2 +-
>  drivers/hwmon/pmbus/Kconfig         |  2 +-
>  drivers/i2c/Kconfig                 |  4 ++--
>  drivers/iio/Kconfig                 |  4 ++--
>  drivers/isdn/hardware/mISDN/Kconfig |  2 +-
>  drivers/md/Kconfig                  |  4 ++--
>  drivers/md/persistent-data/Kconfig  |  2 +-
>  drivers/net/ethernet/ti/Kconfig     |  4 ++--
>  drivers/net/usb/Kconfig             | 12 ++++++------
>  drivers/net/wireless/rt2x00/Kconfig |  6 +++---
>  drivers/pci/pcie/aer/Kconfig        |  2 +-
>  drivers/rtc/Kconfig                 |  8 ++++----
>  drivers/spi/Kconfig                 |  6 +++---
>  drivers/staging/board/Kconfig       |  2 +-
>  drivers/staging/emxx_udc/Kconfig    |  2 +-
>  drivers/staging/iio/Kconfig         |  4 ++--
>  drivers/tty/serial/Kconfig          |  2 +-
>  drivers/usb/gadget/Kconfig          | 34 +++++++++++++++++-----------------
>  drivers/usb/gadget/legacy/Kconfig   |  2 +-
>  drivers/usb/gadget/udc/Kconfig      |  4 ++--
>  drivers/usb/phy/Kconfig             |  2 +-
>  init/Kconfig                        |  4 ++--
>  lib/Kconfig                         | 30 +++++++++++++++---------------
>  mm/Kconfig                          | 22 +++++++++++-----------
>  net/Kconfig                         | 14 +++++++-------
>  net/sched/Kconfig                   |  2 +-
>  net/switchdev/Kconfig               |  2 +-
>  security/integrity/Kconfig          |  4 ++--
>  security/integrity/evm/Kconfig      |  2 +-
>  31 files changed, 99 insertions(+), 99 deletions(-)
> 
> diff --git a/arch/mips/pmcs-msp71xx/Kconfig b/arch/mips/pmcs-msp71xx/Kconfig
> index 6073ca4..4190093 100644
> --- a/arch/mips/pmcs-msp71xx/Kconfig
> +++ b/arch/mips/pmcs-msp71xx/Kconfig
> @@ -36,14 +36,14 @@ config PMC_MSP7120_FPGA
>  endchoice
>  
>  config MSP_HAS_USB
> -	boolean
> +	bool
>  	depends on PMC_MSP
>  
>  config MSP_ETH
> -	boolean
> +	bool
>  	select MSP_HAS_MAC
>  	depends on PMC_MSP
>  
>  config MSP_HAS_MAC
> -	boolean
> +	bool
>  	depends on PMC_MSP
> diff --git a/drivers/connector/Kconfig b/drivers/connector/Kconfig
> index 6e6730f..3de5f3a 100644
> --- a/drivers/connector/Kconfig
> +++ b/drivers/connector/Kconfig
> @@ -12,7 +12,7 @@ menuconfig CONNECTOR
>  if CONNECTOR
>  
>  config PROC_EVENTS
> -	boolean "Report process events to userspace"
> +	bool "Report process events to userspace"
>  	depends on CONNECTOR=y
>  	default y
>  	---help---
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 6529c09..33149a4 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1595,7 +1595,7 @@ config SENSORS_W83795
>  	  will be called w83795.
>  
>  config SENSORS_W83795_FANCTRL
> -	boolean "Include automatic fan control support (DANGEROUS)"
> +	bool "Include automatic fan control support (DANGEROUS)"
>  	depends on SENSORS_W83795
>  	default n
>  	help
> diff --git a/drivers/hwmon/pmbus/Kconfig b/drivers/hwmon/pmbus/Kconfig
> index a674cd8..9f7dbd1 100644
> --- a/drivers/hwmon/pmbus/Kconfig
> +++ b/drivers/hwmon/pmbus/Kconfig
> @@ -57,7 +57,7 @@ config SENSORS_LTC2978
>  	  be called ltc2978.
>  
>  config SENSORS_LTC2978_REGULATOR
> -	boolean "Regulator support for LTC2978 and compatibles"
> +	bool "Regulator support for LTC2978 and compatibles"
>  	depends on SENSORS_LTC2978 && REGULATOR
>  	help
>  	  If you say yes here you get regulator support for Linear
> diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
> index 8c9e619..78fbee4 100644
> --- a/drivers/i2c/Kconfig
> +++ b/drivers/i2c/Kconfig
> @@ -35,11 +35,11 @@ config ACPI_I2C_OPREGION
>  if I2C
>  
>  config I2C_BOARDINFO
> -	boolean
> +	bool
>  	default y
>  
>  config I2C_COMPAT
> -	boolean "Enable compatibility bits for old user-space"
> +	bool "Enable compatibility bits for old user-space"
>  	default y
>  	help
>  	  Say Y here if you intend to run lm-sensors 3.1.1 or older, or any
> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
> index 345395e..397c8df 100644
> --- a/drivers/iio/Kconfig
> +++ b/drivers/iio/Kconfig
> @@ -21,7 +21,7 @@ config IIO_BUFFER
>  if IIO_BUFFER
>  
>  config IIO_BUFFER_CB
> -boolean "IIO callback buffer used for push in-kernel interfaces"
> +	bool "IIO callback buffer used for push in-kernel interfaces"
>  	help
>  	  Should be selected by any drivers that do in-kernel push
>  	  usage.  That is, those where the data is pushed to the consumer.
> @@ -44,7 +44,7 @@ config IIO_TRIGGERED_BUFFER
>  endif # IIO_BUFFER
>  
>  config IIO_TRIGGER
> -	boolean "Enable triggered sampling support"
> +	bool "Enable triggered sampling support"
>  	help
>  	  Provides IIO core support for triggers.  Currently these
>  	  are used to initialize capture of samples to push into
> diff --git a/drivers/isdn/hardware/mISDN/Kconfig b/drivers/isdn/hardware/mISDN/Kconfig
> index b8611e3..09df54f 100644
> --- a/drivers/isdn/hardware/mISDN/Kconfig
> +++ b/drivers/isdn/hardware/mISDN/Kconfig
> @@ -24,7 +24,7 @@ config MISDN_HFCMULTI
>  	   * HFC-E1 (E1 interface for 2Mbit ISDN)
>  
>  config MISDN_HFCMULTI_8xx
> -	boolean "Support for XHFC embedded board in HFC multiport driver"
> +	bool "Support for XHFC embedded board in HFC multiport driver"
>  	depends on MISDN
>  	depends on MISDN_HFCMULTI
>  	depends on 8xx
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 5bdedf6..1cd9cf8 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -177,7 +177,7 @@ config MD_FAULTY
>  source "drivers/md/bcache/Kconfig"
>  
>  config BLK_DEV_DM_BUILTIN
> -	boolean
> +	bool
>  
>  config BLK_DEV_DM
>  	tristate "Device mapper support"
> @@ -196,7 +196,7 @@ config BLK_DEV_DM
>  	  If unsure, say N.
>  
>  config DM_DEBUG
> -	boolean "Device mapper debugging support"
> +	bool "Device mapper debugging support"
>  	depends on BLK_DEV_DM
>  	---help---
>  	  Enable this for messages that may help debug device-mapper problems.
> diff --git a/drivers/md/persistent-data/Kconfig b/drivers/md/persistent-data/Kconfig
> index 0c2dec7..78c74bb 100644
> --- a/drivers/md/persistent-data/Kconfig
> +++ b/drivers/md/persistent-data/Kconfig
> @@ -8,7 +8,7 @@ config DM_PERSISTENT_DATA
>  	 device-mapper targets such as the thin provisioning target.
>  
>  config DM_DEBUG_BLOCK_STACK_TRACING
> -       boolean "Keep stack trace of persistent data block lock holders"
> +       bool "Keep stack trace of persistent data block lock holders"
>         depends on STACKTRACE_SUPPORT && DM_PERSISTENT_DATA
>         select STACKTRACE
>         ---help---
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index 605dd90..ca37fb2 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -50,7 +50,7 @@ config TI_DAVINCI_CPDMA
>  	  will be called davinci_cpdma.  This is recommended.
>  
>  config TI_CPSW_PHY_SEL
> -	boolean "TI CPSW Switch Phy sel Support"
> +	bool "TI CPSW Switch Phy sel Support"
>  	depends on TI_CPSW
>  	---help---
>  	  This driver supports configuring of the phy mode connected to
> @@ -71,7 +71,7 @@ config TI_CPSW
>  	  will be called cpsw.
>  
>  config TI_CPTS
> -	boolean "TI Common Platform Time Sync (CPTS) Support"
> +	bool "TI Common Platform Time Sync (CPTS) Support"
>  	depends on TI_CPSW
>  	select PTP_1588_CLOCK
>  	---help---
> diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
> index 37eed4d..3bd9678 100644
> --- a/drivers/net/usb/Kconfig
> +++ b/drivers/net/usb/Kconfig
> @@ -397,14 +397,14 @@ config USB_NET_CDC_SUBSET
>  	  not generally have permanently assigned Ethernet addresses.
>  
>  config USB_ALI_M5632
> -	boolean "ALi M5632 based 'USB 2.0 Data Link' cables"
> +	bool "ALi M5632 based 'USB 2.0 Data Link' cables"
>  	depends on USB_NET_CDC_SUBSET
>  	help
>  	  Choose this option if you're using a host-to-host cable
>  	  based on this design, which supports USB 2.0 high speed.
>  
>  config USB_AN2720
> -	boolean "AnchorChips 2720 based cables (Xircom PGUNET, ...)"
> +	bool "AnchorChips 2720 based cables (Xircom PGUNET, ...)"
>  	depends on USB_NET_CDC_SUBSET
>  	help
>  	  Choose this option if you're using a host-to-host cable
> @@ -412,7 +412,7 @@ config USB_AN2720
>  	  Cypress brand.
>  
>  config USB_BELKIN
> -	boolean "eTEK based host-to-host cables (Advance, Belkin, ...)"
> +	bool "eTEK based host-to-host cables (Advance, Belkin, ...)"
>  	depends on USB_NET_CDC_SUBSET
>  	default y
>  	help
> @@ -421,7 +421,7 @@ config USB_BELKIN
>  	  microcontroller, with LEDs that indicate traffic.
>  
>  config USB_ARMLINUX
> -	boolean "Embedded ARM Linux links (iPaq, ...)"
> +	bool "Embedded ARM Linux links (iPaq, ...)"
>  	depends on USB_NET_CDC_SUBSET
>  	default y
>  	help
> @@ -438,14 +438,14 @@ config USB_ARMLINUX
>  	  this simpler protocol by installing a different kernel.
>  
>  config USB_EPSON2888
> -	boolean "Epson 2888 based firmware (DEVELOPMENT)"
> +	bool "Epson 2888 based firmware (DEVELOPMENT)"
>  	depends on USB_NET_CDC_SUBSET
>  	help
>  	  Choose this option to support the usb networking links used
>  	  by some sample firmware from Epson.
>  
>  config USB_KC2190
> -	boolean "KT Technology KC2190 based cables (InstaNet)"
> +	bool "KT Technology KC2190 based cables (InstaNet)"
>  	depends on USB_NET_CDC_SUBSET
>  	help
>  	  Choose this option if you're using a host-to-host cable
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index 006b8bc..2b4ef25 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -243,14 +243,14 @@ config RT2X00_LIB
>  	select AVERAGE
>  
>  config RT2X00_LIB_FIRMWARE
> -	boolean
> +	bool
>  	select FW_LOADER
>  
>  config RT2X00_LIB_CRYPTO
> -	boolean
> +	bool
>  
>  config RT2X00_LIB_LEDS
> -	boolean
> +	bool
>  	default y if (RT2X00_LIB=y && LEDS_CLASS=y) || (RT2X00_LIB=m && LEDS_CLASS!=n)
>  
>  config RT2X00_LIB_DEBUGFS
> diff --git a/drivers/pci/pcie/aer/Kconfig b/drivers/pci/pcie/aer/Kconfig
> index 3894402..7d1437b 100644
> --- a/drivers/pci/pcie/aer/Kconfig
> +++ b/drivers/pci/pcie/aer/Kconfig
> @@ -3,7 +3,7 @@
>  #
>  
>  config PCIEAER
> -	boolean "Root Port Advanced Error Reporting support"
> +	bool "Root Port Advanced Error Reporting support"
>  	depends on PCIEPORTBUS
>  	select RAS
>  	default y
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index f15cddf..1de1ea5 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -65,7 +65,7 @@ config RTC_DEBUG
>  comment "RTC interfaces"
>  
>  config RTC_INTF_SYSFS
> -	boolean "/sys/class/rtc/rtcN (sysfs)"
> +	bool "/sys/class/rtc/rtcN (sysfs)"
>  	depends on SYSFS
>  	default RTC_CLASS
>  	help
> @@ -75,7 +75,7 @@ config RTC_INTF_SYSFS
>  	  If unsure, say Y.
>  
>  config RTC_INTF_PROC
> -	boolean "/proc/driver/rtc (procfs for rtcN)"
> +	bool "/proc/driver/rtc (procfs for rtcN)"
>  	depends on PROC_FS
>  	default RTC_CLASS
>  	help
> @@ -88,7 +88,7 @@ config RTC_INTF_PROC
>  	  If unsure, say Y.
>  
>  config RTC_INTF_DEV
> -	boolean "/dev/rtcN (character devices)"
> +	bool "/dev/rtcN (character devices)"
>  	default RTC_CLASS
>  	help
>  	  Say yes here if you want to use your RTCs using the /dev
> @@ -455,7 +455,7 @@ config RTC_DRV_DM355EVM
>  	  Supports the RTC firmware in the MSP430 on the DM355 EVM.
>  
>  config RTC_DRV_TWL92330
> -	boolean "TI TWL92330/Menelaus"
> +	bool "TI TWL92330/Menelaus"
>  	depends on MENELAUS
>  	help
>  	  If you say yes here you get support for the RTC on the
> diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
> index 9982998..ef302c7 100644
> --- a/drivers/spi/Kconfig
> +++ b/drivers/spi/Kconfig
> @@ -29,7 +29,7 @@ menuconfig SPI
>  if SPI
>  
>  config SPI_DEBUG
> -	boolean "Debug support for SPI drivers"
> +	bool "Debug support for SPI drivers"
>  	depends on DEBUG_KERNEL
>  	help
>  	  Say "yes" to enable debug messaging (like dev_dbg and pr_debug),
> @@ -40,8 +40,8 @@ config SPI_DEBUG
>  #
>  
>  config SPI_MASTER
> -#	boolean "SPI Master Support"
> -	boolean
> +#	bool "SPI Master Support"
> +	bool
>  	default SPI
>  	help
>  	  If your system has an master-capable SPI controller (which
> diff --git a/drivers/staging/board/Kconfig b/drivers/staging/board/Kconfig
> index 7eda0b8..0a89ad1 100644
> --- a/drivers/staging/board/Kconfig
> +++ b/drivers/staging/board/Kconfig
> @@ -1,5 +1,5 @@
>  config STAGING_BOARD
> -	boolean "Staging Board Support"
> +	bool "Staging Board Support"
>  	depends on OF_ADDRESS
>  	depends on BROKEN
>  	help
> diff --git a/drivers/staging/emxx_udc/Kconfig b/drivers/staging/emxx_udc/Kconfig
> index 9bc6d3d..cc34020 100644
> --- a/drivers/staging/emxx_udc/Kconfig
> +++ b/drivers/staging/emxx_udc/Kconfig
> @@ -1,5 +1,5 @@
>  config USB_EMXX
> -	boolean "EMXX USB Function Device Controller"
> +	bool "EMXX USB Function Device Controller"
>   	depends on USB_GADGET && (ARCH_SHMOBILE || (ARM && COMPILE_TEST))
>  	help
>  	   The Emma Mobile series of SoCs from Renesas Electronics and
> diff --git a/drivers/staging/iio/Kconfig b/drivers/staging/iio/Kconfig
> index fa38be0..2418302 100644
> --- a/drivers/staging/iio/Kconfig
> +++ b/drivers/staging/iio/Kconfig
> @@ -30,13 +30,13 @@ config IIO_SIMPLE_DUMMY
>  if IIO_SIMPLE_DUMMY
>  
>  config IIO_SIMPLE_DUMMY_EVENTS
> -       boolean "Event generation support"
> +       bool "Event generation support"
>         select IIO_DUMMY_EVGEN
>         help
>           Add some dummy events to the simple dummy driver.
>  
>  config IIO_SIMPLE_DUMMY_BUFFER
> -	boolean "Buffered capture support"
> +	bool "Buffered capture support"
>  	select IIO_BUFFER
>  	select IIO_KFIFO_BUF
>  	help
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index c79b43c..9f439fa 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -498,7 +498,7 @@ config SERIAL_MFD_HSU
>  	select SERIAL_CORE
>  
>  config SERIAL_MFD_HSU_CONSOLE
> -	boolean "Medfile HSU serial console support"
> +	bool "Medfile HSU serial console support"
>  	depends on SERIAL_MFD_HSU=y
>  	select SERIAL_CORE_CONSOLE
>  
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 747ef53..c523f94 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -45,7 +45,7 @@ menuconfig USB_GADGET
>  if USB_GADGET
>  
>  config USB_GADGET_DEBUG
> -	boolean "Debugging messages (DEVELOPMENT)"
> +	bool "Debugging messages (DEVELOPMENT)"
>  	depends on DEBUG_KERNEL
>  	help
>  	   Many controller and gadget drivers will print some debugging
> @@ -73,7 +73,7 @@ config USB_GADGET_VERBOSE
>  	   production build.
>  
>  config USB_GADGET_DEBUG_FILES
> -	boolean "Debugging information files (DEVELOPMENT)"
> +	bool "Debugging information files (DEVELOPMENT)"
>  	depends on PROC_FS
>  	help
>  	   Some of the drivers in the "gadget" framework can expose
> @@ -84,7 +84,7 @@ config USB_GADGET_DEBUG_FILES
>  	   here.  If in doubt, or to conserve kernel memory, say "N".
>  
>  config USB_GADGET_DEBUG_FS
> -	boolean "Debugging information files in debugfs (DEVELOPMENT)"
> +	bool "Debugging information files in debugfs (DEVELOPMENT)"
>  	depends on DEBUG_FS
>  	help
>  	   Some of the drivers in the "gadget" framework can expose
> @@ -230,7 +230,7 @@ config USB_CONFIGFS
>  	  For more information see Documentation/usb/gadget_configfs.txt.
>  
>  config USB_CONFIGFS_SERIAL
> -	boolean "Generic serial bulk in/out"
> +	bool "Generic serial bulk in/out"
>  	depends on USB_CONFIGFS
>  	depends on TTY
>  	select USB_U_SERIAL
> @@ -239,7 +239,7 @@ config USB_CONFIGFS_SERIAL
>  	  The function talks to the Linux-USB generic serial driver.
>  
>  config USB_CONFIGFS_ACM
> -	boolean "Abstract Control Model (CDC ACM)"
> +	bool "Abstract Control Model (CDC ACM)"
>  	depends on USB_CONFIGFS
>  	depends on TTY
>  	select USB_U_SERIAL
> @@ -249,7 +249,7 @@ config USB_CONFIGFS_ACM
>  	  MS-Windows hosts or with the Linux-USB "cdc-acm" driver.
>  
>  config USB_CONFIGFS_OBEX
> -	boolean "Object Exchange Model (CDC OBEX)"
> +	bool "Object Exchange Model (CDC OBEX)"
>  	depends on USB_CONFIGFS
>  	depends on TTY
>  	select USB_U_SERIAL
> @@ -259,7 +259,7 @@ config USB_CONFIGFS_OBEX
>  	  since the kernel itself doesn't implement the OBEX protocol.
>  
>  config USB_CONFIGFS_NCM
> -	boolean "Network Control Model (CDC NCM)"
> +	bool "Network Control Model (CDC NCM)"
>  	depends on USB_CONFIGFS
>  	depends on NET
>  	select USB_U_ETHER
> @@ -270,7 +270,7 @@ config USB_CONFIGFS_NCM
>  	  different alignment possibilities.
>  
>  config USB_CONFIGFS_ECM
> -	boolean "Ethernet Control Model (CDC ECM)"
> +	bool "Ethernet Control Model (CDC ECM)"
>  	depends on USB_CONFIGFS
>  	depends on NET
>  	select USB_U_ETHER
> @@ -282,7 +282,7 @@ config USB_CONFIGFS_ECM
>  	  supported by firmware for smart network devices.
>  
>  config USB_CONFIGFS_ECM_SUBSET
> -	boolean "Ethernet Control Model (CDC ECM) subset"
> +	bool "Ethernet Control Model (CDC ECM) subset"
>  	depends on USB_CONFIGFS
>  	depends on NET
>  	select USB_U_ETHER
> @@ -323,7 +323,7 @@ config USB_CONFIGFS_EEM
>  	  the host is the same (a usbX device), so the differences are minimal.
>  
>  config USB_CONFIGFS_PHONET
> -	boolean "Phonet protocol"
> +	bool "Phonet protocol"
>  	depends on USB_CONFIGFS
>  	depends on NET
>  	depends on PHONET
> @@ -333,7 +333,7 @@ config USB_CONFIGFS_PHONET
>  	  The Phonet protocol implementation for USB device.
>  
>  config USB_CONFIGFS_MASS_STORAGE
> -	boolean "Mass storage"
> +	bool "Mass storage"
>  	depends on USB_CONFIGFS
>  	depends on BLOCK
>  	select USB_F_MASS_STORAGE
> @@ -344,7 +344,7 @@ config USB_CONFIGFS_MASS_STORAGE
>  	  specified as a module parameter or sysfs option.
>  
>  config USB_CONFIGFS_F_LB_SS
> -	boolean "Loopback and sourcesink function (for testing)"
> +	bool "Loopback and sourcesink function (for testing)"
>  	depends on USB_CONFIGFS
>  	select USB_F_SS_LB
>  	help
> @@ -357,7 +357,7 @@ config USB_CONFIGFS_F_LB_SS
>  	  and its driver through a basic set of functional tests.
>  
>  config USB_CONFIGFS_F_FS
> -	boolean "Function filesystem (FunctionFS)"
> +	bool "Function filesystem (FunctionFS)"
>  	depends on USB_CONFIGFS
>  	select USB_F_FS
>  	help
> @@ -369,7 +369,7 @@ config USB_CONFIGFS_F_FS
>  	  mass storage) and other are implemented in user space.
>  
>  config USB_CONFIGFS_F_UAC1
> -	boolean "Audio Class 1.0"
> +	bool "Audio Class 1.0"
>  	depends on USB_CONFIGFS
>  	depends on SND
>  	select USB_LIBCOMPOSITE
> @@ -382,7 +382,7 @@ config USB_CONFIGFS_F_UAC1
>  	  on the device.
>  
>  config USB_CONFIGFS_F_UAC2
> -	boolean "Audio Class 2.0"
> +	bool "Audio Class 2.0"
>  	depends on USB_CONFIGFS
>  	depends on SND
>  	select USB_LIBCOMPOSITE
> @@ -400,7 +400,7 @@ config USB_CONFIGFS_F_UAC2
>  	  wants as audio data to the USB Host.
>  
>  config USB_CONFIGFS_F_MIDI
> -	boolean "MIDI function"
> +	bool "MIDI function"
>  	depends on USB_CONFIGFS
>  	depends on SND
>  	select USB_LIBCOMPOSITE
> @@ -414,7 +414,7 @@ config USB_CONFIGFS_F_MIDI
>  	  ALSA's aconnect utility etc.
>  
>  config USB_CONFIGFS_F_HID
> -	boolean "HID function"
> +	bool "HID function"
>  	depends on USB_CONFIGFS
>  	select USB_F_HID
>  	help
> diff --git a/drivers/usb/gadget/legacy/Kconfig b/drivers/usb/gadget/legacy/Kconfig
> index fd48ef3a..113c87e 100644
> --- a/drivers/usb/gadget/legacy/Kconfig
> +++ b/drivers/usb/gadget/legacy/Kconfig
> @@ -40,7 +40,7 @@ config USB_ZERO
>  	  dynamically linked module called "g_zero".
>  
>  config USB_ZERO_HNPTEST
> -	boolean "HNP Test Device"
> +	bool "HNP Test Device"
>  	depends on USB_ZERO && USB_OTG
>  	help
>  	  You can configure this device to enumerate using the device
> diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
> index b8e213e..674adfe 100644
> --- a/drivers/usb/gadget/udc/Kconfig
> +++ b/drivers/usb/gadget/udc/Kconfig
> @@ -198,7 +198,7 @@ config USB_S3C2410
>  	  S3C2440 processors.
>  
>  config USB_S3C2410_DEBUG
> -	boolean "S3C2410 udc debug messages"
> +	bool "S3C2410 udc debug messages"
>  	depends on USB_S3C2410
>  
>  config USB_S3C_HSUDC
> @@ -287,7 +287,7 @@ config USB_NET2272
>  	  gadget drivers to also be dynamically linked.
>  
>  config USB_NET2272_DMA
> -	boolean "Support external DMA controller"
> +	bool "Support external DMA controller"
>  	depends on USB_NET2272 && HAS_DMA
>  	help
>  	  The NET2272 part can optionally support an external DMA
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index c6d0c8e..52d3d58 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -119,7 +119,7 @@ config TAHVO_USB
>  
>  config TAHVO_USB_HOST_BY_DEFAULT
>  	depends on TAHVO_USB
> -	boolean "Device in USB host mode by default"
> +	bool "Device in USB host mode by default"
>  	help
>  	  Say Y here, if you want the device to enter USB host mode
>  	  by default on bootup.
> diff --git a/init/Kconfig b/init/Kconfig
> index 9afb971..643b221 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -914,7 +914,7 @@ config NUMA_BALANCING_DEFAULT_ENABLED
>  	  machine.
>  
>  menuconfig CGROUPS
> -	boolean "Control Group support"
> +	bool "Control Group support"
>  	select KERNFS
>  	help
>  	  This option adds support for grouping sets of processes together, for
> @@ -1770,7 +1770,7 @@ config SLABINFO
>  	default y
>  
>  config RT_MUTEXES
> -	boolean
> +	bool
>  
>  config BASE_SMALL
>  	int
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 54cf309..75da4d3 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -14,7 +14,7 @@ config BITREVERSE
>  	tristate
>  
>  config RATIONAL
> -	boolean
> +	bool
>  
>  config GENERIC_STRNCPY_FROM_USER
>  	bool
> @@ -39,14 +39,14 @@ config GENERIC_IOMAP
>  	select GENERIC_PCI_IOMAP
>  
>  config GENERIC_IO
> -	boolean
> +	bool
>  	default n
>  
>  config STMP_DEVICE
>  	bool
>  
>  config PERCPU_RWSEM
> -	boolean
> +	bool
>  
>  config ARCH_USE_CMPXCHG_LOCKREF
>  	bool
> @@ -257,7 +257,7 @@ config DECOMPRESS_LZ4
>  # Generic allocator support is selected if needed
>  #
>  config GENERIC_ALLOCATOR
> -	boolean
> +	bool
>  
>  #
>  # reed solomon support is select'ed if needed
> @@ -266,16 +266,16 @@ config REED_SOLOMON
>  	tristate
>  	
>  config REED_SOLOMON_ENC8
> -	boolean
> +	bool
>  
>  config REED_SOLOMON_DEC8
> -	boolean
> +	bool
>  
>  config REED_SOLOMON_ENC16
> -	boolean
> +	bool
>  
>  config REED_SOLOMON_DEC16
> -	boolean
> +	bool
>  
>  #
>  # BCH support is selected if needed
> @@ -284,7 +284,7 @@ config BCH
>  	tristate
>  
>  config BCH_CONST_PARAMS
> -	boolean
> +	bool
>  	help
>  	  Drivers may select this option to force specific constant
>  	  values for parameters 'm' (Galois field order) and 't'
> @@ -320,7 +320,7 @@ config BCH_CONST_T
>  # Textsearch support is select'ed if needed
>  #
>  config TEXTSEARCH
> -	boolean
> +	bool
>  
>  config TEXTSEARCH_KMP
>  	tristate
> @@ -332,10 +332,10 @@ config TEXTSEARCH_FSM
>  	tristate
>  
>  config BTREE
> -	boolean
> +	bool
>  
>  config INTERVAL_TREE
> -	boolean
> +	bool
>  	help
>  	  Simple, embeddable, interval-tree. Can find the start of an
>  	  overlapping range in log(n) time and then iterate over all
> @@ -363,18 +363,18 @@ config ASSOCIATIVE_ARRAY
>  	  for more information.
>  
>  config HAS_IOMEM
> -	boolean
> +	bool
>  	depends on !NO_IOMEM
>  	select GENERIC_IO
>  	default y
>  
>  config HAS_IOPORT_MAP
> -	boolean
> +	bool
>  	depends on HAS_IOMEM && !NO_IOPORT_MAP
>  	default y
>  
>  config HAS_DMA
> -	boolean
> +	bool
>  	depends on !NO_DMA
>  	default y
>  
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 1d1ae6b..3953f41 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -129,28 +129,28 @@ config SPARSEMEM_VMEMMAP
>  	 efficient option when sufficient kernel resources are available.
>  
>  config HAVE_MEMBLOCK
> -	boolean
> +	bool
>  
>  config HAVE_MEMBLOCK_NODE_MAP
> -	boolean
> +	bool
>  
>  config HAVE_MEMBLOCK_PHYS_MAP
> -	boolean
> +	bool
>  
>  config HAVE_GENERIC_RCU_GUP
> -	boolean
> +	bool
>  
>  config ARCH_DISCARD_MEMBLOCK
> -	boolean
> +	bool
>  
>  config NO_BOOTMEM
> -	boolean
> +	bool
>  
>  config MEMORY_ISOLATION
> -	boolean
> +	bool
>  
>  config MOVABLE_NODE
> -	boolean "Enable to assign a node which has only movable memory"
> +	bool "Enable to assign a node which has only movable memory"
>  	depends on HAVE_MEMBLOCK
>  	depends on NO_BOOTMEM
>  	depends on X86_64
> @@ -228,12 +228,12 @@ config SPLIT_PTLOCK_CPUS
>  	default "4"
>  
>  config ARCH_ENABLE_SPLIT_PMD_PTLOCK
> -	boolean
> +	bool
>  
>  #
>  # support for memory balloon
>  config MEMORY_BALLOON
> -	boolean
> +	bool
>  
>  #
>  # support for memory balloon compaction
> @@ -276,7 +276,7 @@ config MIGRATION
>  	  allocation instead of reclaiming.
>  
>  config ARCH_ENABLE_HUGEPAGE_MIGRATION
> -	boolean
> +	bool
>  
>  config PHYS_ADDR_T_64BIT
>  	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
> diff --git a/net/Kconfig b/net/Kconfig
> index ff9ffc1..44dd578 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -231,18 +231,18 @@ source "net/hsr/Kconfig"
>  source "net/switchdev/Kconfig"
>  
>  config RPS
> -	boolean
> +	bool
>  	depends on SMP && SYSFS
>  	default y
>  
>  config RFS_ACCEL
> -	boolean
> +	bool
>  	depends on RPS
>  	select CPU_RMAP
>  	default y
>  
>  config XPS
> -	boolean
> +	bool
>  	depends on SMP
>  	default y
>  
> @@ -254,18 +254,18 @@ config CGROUP_NET_PRIO
>  	  a per-interface basis.
>  
>  config CGROUP_NET_CLASSID
> -	boolean "Network classid cgroup"
> +	bool "Network classid cgroup"
>  	depends on CGROUPS
>  	---help---
>  	  Cgroup subsystem for use as general purpose socket classid marker that is
>  	  being used in cls_cgroup and for netfilter matching.
>  
>  config NET_RX_BUSY_POLL
> -	boolean
> +	bool
>  	default y
>  
>  config BQL
> -	boolean
> +	bool
>  	depends on SYSFS
>  	select DQL
>  	default y
> @@ -282,7 +282,7 @@ config BPF_JIT
>  	  this feature changing /proc/sys/net/core/bpf_jit_enable
>  
>  config NET_FLOW_LIMIT
> -	boolean
> +	bool
>  	depends on RPS
>  	default y
>  	---help---
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index c54c9d9..706af73 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -348,7 +348,7 @@ config NET_SCH_PLUG
>  comment "Classification"
>  
>  config NET_CLS
> -	boolean
> +	bool
>  
>  config NET_CLS_BASIC
>  	tristate "Elementary classification (BASIC)"
> diff --git a/net/switchdev/Kconfig b/net/switchdev/Kconfig
> index 1557545..86a47e1 100644
> --- a/net/switchdev/Kconfig
> +++ b/net/switchdev/Kconfig
> @@ -3,7 +3,7 @@
>  #
>  
>  config NET_SWITCHDEV
> -	boolean "Switch (and switch-ish) device support (EXPERIMENTAL)"
> +	bool "Switch (and switch-ish) device support (EXPERIMENTAL)"
>  	depends on INET
>  	---help---
>  	  This module provides glue between core networking code and device
> diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
> index b76235a..73c457b 100644
> --- a/security/integrity/Kconfig
> +++ b/security/integrity/Kconfig
> @@ -16,7 +16,7 @@ config INTEGRITY
>  if INTEGRITY
>  
>  config INTEGRITY_SIGNATURE
> -	boolean "Digital signature verification using multiple keyrings"
> +	bool "Digital signature verification using multiple keyrings"
>  	depends on KEYS
>  	default n
>  	select SIGNATURE
> @@ -30,7 +30,7 @@ config INTEGRITY_SIGNATURE
>  	  usually only added from initramfs.
>  
>  config INTEGRITY_ASYMMETRIC_KEYS
> -	boolean "Enable asymmetric keys support"
> +	bool "Enable asymmetric keys support"
>  	depends on INTEGRITY_SIGNATURE
>  	default n
>          select ASYMMETRIC_KEY_TYPE
> diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
> index df586fa..bf19723 100644
> --- a/security/integrity/evm/Kconfig
> +++ b/security/integrity/evm/Kconfig
> @@ -1,5 +1,5 @@
>  config EVM
> -	boolean "EVM support"
> +	bool "EVM support"
>  	select KEYS
>  	select ENCRYPTED_KEYS
>  	select CRYPTO_HMAC
> -- 
> 2.1.0
> 

Suggested-by: Daniel Borkmann <dborkman@redhat.com>

Cheers,
Chris
