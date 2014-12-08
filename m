Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaLHB5L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 20:57:11 -0500
Received: from smtprelay01.ispgateway.de ([80.67.18.43]:52310 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaLHB4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 20:56:52 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Dec 2014 20:56:51 EST
From: Christoph Jaeger <cj@linux.com>
To: yann.morin.1998@free.fr
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dborkman@redhat.com, Christoph Jaeger <cj@linux.com>
Subject: [PATCH 2/3] kconfig: remove undocumented type definition alias 'boolean'
Date: Sun,  7 Dec 2014 20:49:19 -0500
Message-Id: <1539c3778a0f3533942f69540a9b5b3d1f965bdc.1418003065.git.cj@linux.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1418003065.git.cj@linux.com>
References: <cover.1418003065.git.cj@linux.com>
In-Reply-To: <cover.1418003065.git.cj@linux.com>
References: <cover.1418003065.git.cj@linux.com>
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having an undocumented alias for type definitions of boolean config options is
more confusing than helpful. Remove support for the keyword 'boolean' in favor
of 'bool' and convert all its users.

While at it, fix some minor grammar issues in warning messages.

Suggested-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Christoph Jaeger <cj@linux.com>
---
 arch/cris/arch-v32/drivers/Kconfig   |  2 +-
 arch/mips/pmcs-msp71xx/Kconfig       |  6 ++---
 drivers/connector/Kconfig            |  2 +-
 drivers/hwmon/Kconfig                |  2 +-
 drivers/i2c/Kconfig                  |  4 +--
 drivers/iio/Kconfig                  |  4 +--
 drivers/isdn/hardware/mISDN/Kconfig  |  2 +-
 drivers/md/Kconfig                   |  4 +--
 drivers/md/persistent-data/Kconfig   |  2 +-
 drivers/net/ethernet/ti/Kconfig      |  4 +--
 drivers/net/usb/Kconfig              | 12 ++++-----
 drivers/net/wireless/rt2x00/Kconfig  |  6 ++---
 drivers/pci/pcie/aer/Kconfig         |  2 +-
 drivers/rtc/Kconfig                  |  8 +++---
 drivers/spi/Kconfig                  |  6 ++---
 drivers/staging/board/Kconfig        |  2 +-
 drivers/staging/emxx_udc/Kconfig     |  2 +-
 drivers/staging/iio/Kconfig          |  4 +--
 drivers/tty/serial/Kconfig           |  2 +-
 drivers/usb/gadget/Kconfig           | 26 +++++++++---------
 drivers/usb/gadget/legacy/Kconfig    |  2 +-
 drivers/usb/gadget/udc/Kconfig       |  4 +--
 drivers/usb/phy/Kconfig              |  2 +-
 init/Kconfig                         |  4 +--
 lib/Kconfig                          | 30 ++++++++++-----------
 mm/Kconfig                           | 22 ++++++++--------
 net/Kconfig                          | 14 +++++-----
 net/sched/Kconfig                    |  2 +-
 scripts/kconfig/confdata.c           |  2 +-
 scripts/kconfig/mconf.c              |  2 +-
 scripts/kconfig/menu.c               |  6 ++---
 scripts/kconfig/symbol.c             |  2 +-
 scripts/kconfig/zconf.gperf          |  1 -
 scripts/kconfig/zconf.hash.c_shipped | 51 ++++++++++++++++--------------------
 scripts/kconfig/zconf.tab.c_shipped  |  2 +-
 scripts/kconfig/zconf.y              |  2 +-
 security/integrity/Kconfig           |  4 +--
 security/integrity/evm/Kconfig       |  2 +-
 38 files changed, 125 insertions(+), 131 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index 15a9ed1..441e2a1 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -363,7 +363,7 @@ config ETRAX_SPI_MMC
 # For the parts that can't be a module (due to restrictions in
 # framework elsewhere).
 config ETRAX_SPI_MMC_BOARD
-       boolean
+       bool
        default n
 
 # While the board info is MMC_SPI only, the drivers are written to be
diff --git a/arch/mips/pmcs-msp71xx/Kconfig b/arch/mips/pmcs-msp71xx/Kconfig
index 6073ca4..4190093 100644
--- a/arch/mips/pmcs-msp71xx/Kconfig
+++ b/arch/mips/pmcs-msp71xx/Kconfig
@@ -36,14 +36,14 @@ config PMC_MSP7120_FPGA
 endchoice
 
 config MSP_HAS_USB
-	boolean
+	bool
 	depends on PMC_MSP
 
 config MSP_ETH
-	boolean
+	bool
 	select MSP_HAS_MAC
 	depends on PMC_MSP
 
 config MSP_HAS_MAC
-	boolean
+	bool
 	depends on PMC_MSP
diff --git a/drivers/connector/Kconfig b/drivers/connector/Kconfig
index 6e6730f..3de5f3a 100644
--- a/drivers/connector/Kconfig
+++ b/drivers/connector/Kconfig
@@ -12,7 +12,7 @@ menuconfig CONNECTOR
 if CONNECTOR
 
 config PROC_EVENTS
-	boolean "Report process events to userspace"
+	bool "Report process events to userspace"
 	depends on CONNECTOR=y
 	default y
 	---help---
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 5286d7c..a423bfa 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1583,7 +1583,7 @@ config SENSORS_W83795
 	  will be called w83795.
 
 config SENSORS_W83795_FANCTRL
-	boolean "Include automatic fan control support (DANGEROUS)"
+	bool "Include automatic fan control support (DANGEROUS)"
 	depends on SENSORS_W83795
 	default n
 	help
diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index b51a402..55a1636 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -35,11 +35,11 @@ config ACPI_I2C_OPREGION
 if I2C
 
 config I2C_BOARDINFO
-	boolean
+	bool
 	default y
 
 config I2C_COMPAT
-	boolean "Enable compatibility bits for old user-space"
+	bool "Enable compatibility bits for old user-space"
 	default y
 	help
 	  Say Y here if you intend to run lm-sensors 3.1.1 or older, or any
diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index 345395e..397c8df 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -21,7 +21,7 @@ config IIO_BUFFER
 if IIO_BUFFER
 
 config IIO_BUFFER_CB
-boolean "IIO callback buffer used for push in-kernel interfaces"
+	bool "IIO callback buffer used for push in-kernel interfaces"
 	help
 	  Should be selected by any drivers that do in-kernel push
 	  usage.  That is, those where the data is pushed to the consumer.
@@ -44,7 +44,7 @@ config IIO_TRIGGERED_BUFFER
 endif # IIO_BUFFER
 
 config IIO_TRIGGER
-	boolean "Enable triggered sampling support"
+	bool "Enable triggered sampling support"
 	help
 	  Provides IIO core support for triggers.  Currently these
 	  are used to initialize capture of samples to push into
diff --git a/drivers/isdn/hardware/mISDN/Kconfig b/drivers/isdn/hardware/mISDN/Kconfig
index b8611e3..09df54f 100644
--- a/drivers/isdn/hardware/mISDN/Kconfig
+++ b/drivers/isdn/hardware/mISDN/Kconfig
@@ -24,7 +24,7 @@ config MISDN_HFCMULTI
 	   * HFC-E1 (E1 interface for 2Mbit ISDN)
 
 config MISDN_HFCMULTI_8xx
-	boolean "Support for XHFC embedded board in HFC multiport driver"
+	bool "Support for XHFC embedded board in HFC multiport driver"
 	depends on MISDN
 	depends on MISDN_HFCMULTI
 	depends on 8xx
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 5bdedf6..1cd9cf8 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -177,7 +177,7 @@ config MD_FAULTY
 source "drivers/md/bcache/Kconfig"
 
 config BLK_DEV_DM_BUILTIN
-	boolean
+	bool
 
 config BLK_DEV_DM
 	tristate "Device mapper support"
@@ -196,7 +196,7 @@ config BLK_DEV_DM
 	  If unsure, say N.
 
 config DM_DEBUG
-	boolean "Device mapper debugging support"
+	bool "Device mapper debugging support"
 	depends on BLK_DEV_DM
 	---help---
 	  Enable this for messages that may help debug device-mapper problems.
diff --git a/drivers/md/persistent-data/Kconfig b/drivers/md/persistent-data/Kconfig
index 0c2dec7..78c74bb 100644
--- a/drivers/md/persistent-data/Kconfig
+++ b/drivers/md/persistent-data/Kconfig
@@ -8,7 +8,7 @@ config DM_PERSISTENT_DATA
 	 device-mapper targets such as the thin provisioning target.
 
 config DM_DEBUG_BLOCK_STACK_TRACING
-       boolean "Keep stack trace of persistent data block lock holders"
+       bool "Keep stack trace of persistent data block lock holders"
        depends on STACKTRACE_SUPPORT && DM_PERSISTENT_DATA
        select STACKTRACE
        ---help---
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 5d8cb79..9720bd9 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -50,7 +50,7 @@ config TI_DAVINCI_CPDMA
 	  will be called davinci_cpdma.  This is recommended.
 
 config TI_CPSW_PHY_SEL
-	boolean "TI CPSW Switch Phy sel Support"
+	bool "TI CPSW Switch Phy sel Support"
 	depends on TI_CPSW
 	---help---
 	  This driver supports configuring of the phy mode connected to
@@ -71,7 +71,7 @@ config TI_CPSW
 	  will be called cpsw.
 
 config TI_CPTS
-	boolean "TI Common Platform Time Sync (CPTS) Support"
+	bool "TI Common Platform Time Sync (CPTS) Support"
 	depends on TI_CPSW
 	select PTP_1588_CLOCK
 	---help---
diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 37eed4d..3bd9678 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -397,14 +397,14 @@ config USB_NET_CDC_SUBSET
 	  not generally have permanently assigned Ethernet addresses.
 
 config USB_ALI_M5632
-	boolean "ALi M5632 based 'USB 2.0 Data Link' cables"
+	bool "ALi M5632 based 'USB 2.0 Data Link' cables"
 	depends on USB_NET_CDC_SUBSET
 	help
 	  Choose this option if you're using a host-to-host cable
 	  based on this design, which supports USB 2.0 high speed.
 
 config USB_AN2720
-	boolean "AnchorChips 2720 based cables (Xircom PGUNET, ...)"
+	bool "AnchorChips 2720 based cables (Xircom PGUNET, ...)"
 	depends on USB_NET_CDC_SUBSET
 	help
 	  Choose this option if you're using a host-to-host cable
@@ -412,7 +412,7 @@ config USB_AN2720
 	  Cypress brand.
 
 config USB_BELKIN
-	boolean "eTEK based host-to-host cables (Advance, Belkin, ...)"
+	bool "eTEK based host-to-host cables (Advance, Belkin, ...)"
 	depends on USB_NET_CDC_SUBSET
 	default y
 	help
@@ -421,7 +421,7 @@ config USB_BELKIN
 	  microcontroller, with LEDs that indicate traffic.
 
 config USB_ARMLINUX
-	boolean "Embedded ARM Linux links (iPaq, ...)"
+	bool "Embedded ARM Linux links (iPaq, ...)"
 	depends on USB_NET_CDC_SUBSET
 	default y
 	help
@@ -438,14 +438,14 @@ config USB_ARMLINUX
 	  this simpler protocol by installing a different kernel.
 
 config USB_EPSON2888
-	boolean "Epson 2888 based firmware (DEVELOPMENT)"
+	bool "Epson 2888 based firmware (DEVELOPMENT)"
 	depends on USB_NET_CDC_SUBSET
 	help
 	  Choose this option to support the usb networking links used
 	  by some sample firmware from Epson.
 
 config USB_KC2190
-	boolean "KT Technology KC2190 based cables (InstaNet)"
+	bool "KT Technology KC2190 based cables (InstaNet)"
 	depends on USB_NET_CDC_SUBSET
 	help
 	  Choose this option if you're using a host-to-host cable
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 006b8bc..2b4ef25 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -243,14 +243,14 @@ config RT2X00_LIB
 	select AVERAGE
 
 config RT2X00_LIB_FIRMWARE
-	boolean
+	bool
 	select FW_LOADER
 
 config RT2X00_LIB_CRYPTO
-	boolean
+	bool
 
 config RT2X00_LIB_LEDS
-	boolean
+	bool
 	default y if (RT2X00_LIB=y && LEDS_CLASS=y) || (RT2X00_LIB=m && LEDS_CLASS!=n)
 
 config RT2X00_LIB_DEBUGFS
diff --git a/drivers/pci/pcie/aer/Kconfig b/drivers/pci/pcie/aer/Kconfig
index 3894402..7d1437b 100644
--- a/drivers/pci/pcie/aer/Kconfig
+++ b/drivers/pci/pcie/aer/Kconfig
@@ -3,7 +3,7 @@
 #
 
 config PCIEAER
-	boolean "Root Port Advanced Error Reporting support"
+	bool "Root Port Advanced Error Reporting support"
 	depends on PCIEPORTBUS
 	select RAS
 	default y
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 6dd12dd..8c3592a 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -65,7 +65,7 @@ config RTC_DEBUG
 comment "RTC interfaces"
 
 config RTC_INTF_SYSFS
-	boolean "/sys/class/rtc/rtcN (sysfs)"
+	bool "/sys/class/rtc/rtcN (sysfs)"
 	depends on SYSFS
 	default RTC_CLASS
 	help
@@ -75,7 +75,7 @@ config RTC_INTF_SYSFS
 	  If unsure, say Y.
 
 config RTC_INTF_PROC
-	boolean "/proc/driver/rtc (procfs for rtcN)"
+	bool "/proc/driver/rtc (procfs for rtcN)"
 	depends on PROC_FS
 	default RTC_CLASS
 	help
@@ -88,7 +88,7 @@ config RTC_INTF_PROC
 	  If unsure, say Y.
 
 config RTC_INTF_DEV
-	boolean "/dev/rtcN (character devices)"
+	bool "/dev/rtcN (character devices)"
 	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using the /dev
@@ -447,7 +447,7 @@ config RTC_DRV_DM355EVM
 	  Supports the RTC firmware in the MSP430 on the DM355 EVM.
 
 config RTC_DRV_TWL92330
-	boolean "TI TWL92330/Menelaus"
+	bool "TI TWL92330/Menelaus"
 	depends on MENELAUS
 	help
 	  If you say yes here you get support for the RTC on the
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 84e7c9e..14953c3 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -29,7 +29,7 @@ menuconfig SPI
 if SPI
 
 config SPI_DEBUG
-	boolean "Debug support for SPI drivers"
+	bool "Debug support for SPI drivers"
 	depends on DEBUG_KERNEL
 	help
 	  Say "yes" to enable debug messaging (like dev_dbg and pr_debug),
@@ -40,8 +40,8 @@ config SPI_DEBUG
 #
 
 config SPI_MASTER
-#	boolean "SPI Master Support"
-	boolean
+#	bool "SPI Master Support"
+	bool
 	default SPI
 	help
 	  If your system has an master-capable SPI controller (which
diff --git a/drivers/staging/board/Kconfig b/drivers/staging/board/Kconfig
index 7eda0b8..0a89ad1 100644
--- a/drivers/staging/board/Kconfig
+++ b/drivers/staging/board/Kconfig
@@ -1,5 +1,5 @@
 config STAGING_BOARD
-	boolean "Staging Board Support"
+	bool "Staging Board Support"
 	depends on OF_ADDRESS
 	depends on BROKEN
 	help
diff --git a/drivers/staging/emxx_udc/Kconfig b/drivers/staging/emxx_udc/Kconfig
index 9bc6d3d..cc34020 100644
--- a/drivers/staging/emxx_udc/Kconfig
+++ b/drivers/staging/emxx_udc/Kconfig
@@ -1,5 +1,5 @@
 config USB_EMXX
-	boolean "EMXX USB Function Device Controller"
+	bool "EMXX USB Function Device Controller"
  	depends on USB_GADGET && (ARCH_SHMOBILE || (ARM && COMPILE_TEST))
 	help
 	   The Emma Mobile series of SoCs from Renesas Electronics and
diff --git a/drivers/staging/iio/Kconfig b/drivers/staging/iio/Kconfig
index fa38be0..2418302 100644
--- a/drivers/staging/iio/Kconfig
+++ b/drivers/staging/iio/Kconfig
@@ -30,13 +30,13 @@ config IIO_SIMPLE_DUMMY
 if IIO_SIMPLE_DUMMY
 
 config IIO_SIMPLE_DUMMY_EVENTS
-       boolean "Event generation support"
+       bool "Event generation support"
        select IIO_DUMMY_EVGEN
        help
          Add some dummy events to the simple dummy driver.
 
 config IIO_SIMPLE_DUMMY_BUFFER
-	boolean "Buffered capture support"
+	bool "Buffered capture support"
 	select IIO_BUFFER
 	select IIO_KFIFO_BUF
 	help
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 649b784..fc80a50 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -498,7 +498,7 @@ config SERIAL_MFD_HSU
 	select SERIAL_CORE
 
 config SERIAL_MFD_HSU_CONSOLE
-	boolean "Medfile HSU serial console support"
+	bool "Medfile HSU serial console support"
 	depends on SERIAL_MFD_HSU=y
 	select SERIAL_CORE_CONSOLE
 
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index c4880fc..c9e269d 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -45,7 +45,7 @@ menuconfig USB_GADGET
 if USB_GADGET
 
 config USB_GADGET_DEBUG
-	boolean "Debugging messages (DEVELOPMENT)"
+	bool "Debugging messages (DEVELOPMENT)"
 	depends on DEBUG_KERNEL
 	help
 	   Many controller and gadget drivers will print some debugging
@@ -73,7 +73,7 @@ config USB_GADGET_VERBOSE
 	   production build.
 
 config USB_GADGET_DEBUG_FILES
-	boolean "Debugging information files (DEVELOPMENT)"
+	bool "Debugging information files (DEVELOPMENT)"
 	depends on PROC_FS
 	help
 	   Some of the drivers in the "gadget" framework can expose
@@ -84,7 +84,7 @@ config USB_GADGET_DEBUG_FILES
 	   here.  If in doubt, or to conserve kernel memory, say "N".
 
 config USB_GADGET_DEBUG_FS
-	boolean "Debugging information files in debugfs (DEVELOPMENT)"
+	bool "Debugging information files in debugfs (DEVELOPMENT)"
 	depends on DEBUG_FS
 	help
 	   Some of the drivers in the "gadget" framework can expose
@@ -224,7 +224,7 @@ config USB_CONFIGFS
 	  For more information see Documentation/usb/gadget_configfs.txt.
 
 config USB_CONFIGFS_SERIAL
-	boolean "Generic serial bulk in/out"
+	bool "Generic serial bulk in/out"
 	depends on USB_CONFIGFS
 	depends on TTY
 	select USB_U_SERIAL
@@ -233,7 +233,7 @@ config USB_CONFIGFS_SERIAL
 	  The function talks to the Linux-USB generic serial driver.
 
 config USB_CONFIGFS_ACM
-	boolean "Abstract Control Model (CDC ACM)"
+	bool "Abstract Control Model (CDC ACM)"
 	depends on USB_CONFIGFS
 	depends on TTY
 	select USB_U_SERIAL
@@ -243,7 +243,7 @@ config USB_CONFIGFS_ACM
 	  MS-Windows hosts or with the Linux-USB "cdc-acm" driver.
 
 config USB_CONFIGFS_OBEX
-	boolean "Object Exchange Model (CDC OBEX)"
+	bool "Object Exchange Model (CDC OBEX)"
 	depends on USB_CONFIGFS
 	depends on TTY
 	select USB_U_SERIAL
@@ -253,7 +253,7 @@ config USB_CONFIGFS_OBEX
 	  since the kernel itself doesn't implement the OBEX protocol.
 
 config USB_CONFIGFS_NCM
-	boolean "Network Control Model (CDC NCM)"
+	bool "Network Control Model (CDC NCM)"
 	depends on USB_CONFIGFS
 	depends on NET
 	select USB_U_ETHER
@@ -264,7 +264,7 @@ config USB_CONFIGFS_NCM
 	  different alignment possibilities.
 
 config USB_CONFIGFS_ECM
-	boolean "Ethernet Control Model (CDC ECM)"
+	bool "Ethernet Control Model (CDC ECM)"
 	depends on USB_CONFIGFS
 	depends on NET
 	select USB_U_ETHER
@@ -276,7 +276,7 @@ config USB_CONFIGFS_ECM
 	  supported by firmware for smart network devices.
 
 config USB_CONFIGFS_ECM_SUBSET
-	boolean "Ethernet Control Model (CDC ECM) subset"
+	bool "Ethernet Control Model (CDC ECM) subset"
 	depends on USB_CONFIGFS
 	depends on NET
 	select USB_U_ETHER
@@ -317,7 +317,7 @@ config USB_CONFIGFS_EEM
 	  the host is the same (a usbX device), so the differences are minimal.
 
 config USB_CONFIGFS_PHONET
-	boolean "Phonet protocol"
+	bool "Phonet protocol"
 	depends on USB_CONFIGFS
 	depends on NET
 	depends on PHONET
@@ -327,7 +327,7 @@ config USB_CONFIGFS_PHONET
 	  The Phonet protocol implementation for USB device.
 
 config USB_CONFIGFS_MASS_STORAGE
-	boolean "Mass storage"
+	bool "Mass storage"
 	depends on USB_CONFIGFS
 	depends on BLOCK
 	select USB_F_MASS_STORAGE
@@ -338,7 +338,7 @@ config USB_CONFIGFS_MASS_STORAGE
 	  specified as a module parameter or sysfs option.
 
 config USB_CONFIGFS_F_LB_SS
-	boolean "Loopback and sourcesink function (for testing)"
+	bool "Loopback and sourcesink function (for testing)"
 	depends on USB_CONFIGFS
 	select USB_F_SS_LB
 	help
@@ -351,7 +351,7 @@ config USB_CONFIGFS_F_LB_SS
 	  and its driver through a basic set of functional tests.
 
 config USB_CONFIGFS_F_FS
-	boolean "Function filesystem (FunctionFS)"
+	bool "Function filesystem (FunctionFS)"
 	depends on USB_CONFIGFS
 	select USB_F_FS
 	help
diff --git a/drivers/usb/gadget/legacy/Kconfig b/drivers/usb/gadget/legacy/Kconfig
index 24392d2..e9020cc 100644
--- a/drivers/usb/gadget/legacy/Kconfig
+++ b/drivers/usb/gadget/legacy/Kconfig
@@ -40,7 +40,7 @@ config USB_ZERO
 	  dynamically linked module called "g_zero".
 
 config USB_ZERO_HNPTEST
-	boolean "HNP Test Device"
+	bool "HNP Test Device"
 	depends on USB_ZERO && USB_OTG
 	help
 	  You can configure this device to enumerate using the device
diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index 217365d..ef956aa 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -198,7 +198,7 @@ config USB_S3C2410
 	  S3C2440 processors.
 
 config USB_S3C2410_DEBUG
-	boolean "S3C2410 udc debug messages"
+	bool "S3C2410 udc debug messages"
 	depends on USB_S3C2410
 
 config USB_S3C_HSUDC
@@ -285,7 +285,7 @@ config USB_NET2272
 	  gadget drivers to also be dynamically linked.
 
 config USB_NET2272_DMA
-	boolean "Support external DMA controller"
+	bool "Support external DMA controller"
 	depends on USB_NET2272 && HAS_DMA
 	help
 	  The NET2272 part can optionally support an external DMA
diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 0cd1f44..5b14d65 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -119,7 +119,7 @@ config TAHVO_USB
 
 config TAHVO_USB_HOST_BY_DEFAULT
 	depends on TAHVO_USB
-	boolean "Device in USB host mode by default"
+	bool "Device in USB host mode by default"
 	help
 	  Say Y here, if you want the device to enter USB host mode
 	  by default on bootup.
diff --git a/init/Kconfig b/init/Kconfig
index 2081a4d..10101dc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -921,7 +921,7 @@ config NUMA_BALANCING
 	  This system will be inactive on UMA systems.
 
 menuconfig CGROUPS
-	boolean "Control Group support"
+	bool "Control Group support"
 	select KERNFS
 	help
 	  This option adds support for grouping sets of processes together, for
@@ -1775,7 +1775,7 @@ config SLABINFO
 	default y
 
 config RT_MUTEXES
-	boolean
+	bool
 
 config BASE_SMALL
 	int
diff --git a/lib/Kconfig b/lib/Kconfig
index 54cf309..75da4d3 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -14,7 +14,7 @@ config BITREVERSE
 	tristate
 
 config RATIONAL
-	boolean
+	bool
 
 config GENERIC_STRNCPY_FROM_USER
 	bool
@@ -39,14 +39,14 @@ config GENERIC_IOMAP
 	select GENERIC_PCI_IOMAP
 
 config GENERIC_IO
-	boolean
+	bool
 	default n
 
 config STMP_DEVICE
 	bool
 
 config PERCPU_RWSEM
-	boolean
+	bool
 
 config ARCH_USE_CMPXCHG_LOCKREF
 	bool
@@ -257,7 +257,7 @@ config DECOMPRESS_LZ4
 # Generic allocator support is selected if needed
 #
 config GENERIC_ALLOCATOR
-	boolean
+	bool
 
 #
 # reed solomon support is select'ed if needed
@@ -266,16 +266,16 @@ config REED_SOLOMON
 	tristate
 	
 config REED_SOLOMON_ENC8
-	boolean
+	bool
 
 config REED_SOLOMON_DEC8
-	boolean
+	bool
 
 config REED_SOLOMON_ENC16
-	boolean
+	bool
 
 config REED_SOLOMON_DEC16
-	boolean
+	bool
 
 #
 # BCH support is selected if needed
@@ -284,7 +284,7 @@ config BCH
 	tristate
 
 config BCH_CONST_PARAMS
-	boolean
+	bool
 	help
 	  Drivers may select this option to force specific constant
 	  values for parameters 'm' (Galois field order) and 't'
@@ -320,7 +320,7 @@ config BCH_CONST_T
 # Textsearch support is select'ed if needed
 #
 config TEXTSEARCH
-	boolean
+	bool
 
 config TEXTSEARCH_KMP
 	tristate
@@ -332,10 +332,10 @@ config TEXTSEARCH_FSM
 	tristate
 
 config BTREE
-	boolean
+	bool
 
 config INTERVAL_TREE
-	boolean
+	bool
 	help
 	  Simple, embeddable, interval-tree. Can find the start of an
 	  overlapping range in log(n) time and then iterate over all
@@ -363,18 +363,18 @@ config ASSOCIATIVE_ARRAY
 	  for more information.
 
 config HAS_IOMEM
-	boolean
+	bool
 	depends on !NO_IOMEM
 	select GENERIC_IO
 	default y
 
 config HAS_IOPORT_MAP
-	boolean
+	bool
 	depends on HAS_IOMEM && !NO_IOPORT_MAP
 	default y
 
 config HAS_DMA
-	boolean
+	bool
 	depends on !NO_DMA
 	default y
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 1d1ae6b..3953f41 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -129,28 +129,28 @@ config SPARSEMEM_VMEMMAP
 	 efficient option when sufficient kernel resources are available.
 
 config HAVE_MEMBLOCK
-	boolean
+	bool
 
 config HAVE_MEMBLOCK_NODE_MAP
-	boolean
+	bool
 
 config HAVE_MEMBLOCK_PHYS_MAP
-	boolean
+	bool
 
 config HAVE_GENERIC_RCU_GUP
-	boolean
+	bool
 
 config ARCH_DISCARD_MEMBLOCK
-	boolean
+	bool
 
 config NO_BOOTMEM
-	boolean
+	bool
 
 config MEMORY_ISOLATION
-	boolean
+	bool
 
 config MOVABLE_NODE
-	boolean "Enable to assign a node which has only movable memory"
+	bool "Enable to assign a node which has only movable memory"
 	depends on HAVE_MEMBLOCK
 	depends on NO_BOOTMEM
 	depends on X86_64
@@ -228,12 +228,12 @@ config SPLIT_PTLOCK_CPUS
 	default "4"
 
 config ARCH_ENABLE_SPLIT_PMD_PTLOCK
-	boolean
+	bool
 
 #
 # support for memory balloon
 config MEMORY_BALLOON
-	boolean
+	bool
 
 #
 # support for memory balloon compaction
@@ -276,7 +276,7 @@ config MIGRATION
 	  allocation instead of reclaiming.
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
-	boolean
+	bool
 
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT || ARCH_PHYS_ADDR_T_64BIT
diff --git a/net/Kconfig b/net/Kconfig
index 99815b5..49e3a54 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -230,18 +230,18 @@ source "net/mpls/Kconfig"
 source "net/hsr/Kconfig"
 
 config RPS
-	boolean
+	bool
 	depends on SMP && SYSFS
 	default y
 
 config RFS_ACCEL
-	boolean
+	bool
 	depends on RPS
 	select CPU_RMAP
 	default y
 
 config XPS
-	boolean
+	bool
 	depends on SMP
 	default y
 
@@ -253,18 +253,18 @@ config CGROUP_NET_PRIO
 	  a per-interface basis.
 
 config CGROUP_NET_CLASSID
-	boolean "Network classid cgroup"
+	bool "Network classid cgroup"
 	depends on CGROUPS
 	---help---
 	  Cgroup subsystem for use as general purpose socket classid marker that is
 	  being used in cls_cgroup and for netfilter matching.
 
 config NET_RX_BUSY_POLL
-	boolean
+	bool
 	default y
 
 config BQL
-	boolean
+	bool
 	depends on SYSFS
 	select DQL
 	default y
@@ -281,7 +281,7 @@ config BPF_JIT
 	  this feature changing /proc/sys/net/core/bpf_jit_enable
 
 config NET_FLOW_LIMIT
-	boolean
+	bool
 	depends on RPS
 	default y
 	---help---
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a1a8e29..1014127 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -347,7 +347,7 @@ config NET_SCH_PLUG
 comment "Classification"
 
 config NET_CLS
-	boolean
+	bool
 
 config NET_CLS_BASIC
 	tristate "Elementary classification (BASIC)"
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index f88d90f..412e66c 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1116,7 +1116,7 @@ void set_all_choice_values(struct symbol *csym)
 bool conf_set_all_new_symbols(enum conf_def_mode mode)
 {
 	struct symbol *sym, *csym;
-	int i, cnt, pby, pty, ptm;	/* pby: probability of boolean  = y
+	int i, cnt, pby, pty, ptm;	/* pby: probability of bool     = y
 					 * pty: probability of tristate = y
 					 * ptm: probability of tristate = m
 					 */
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 14cea74..03fddd5 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -246,7 +246,7 @@ search_help[] = N_(
 	"  Selected by: BAR [=n]\n"
 	"-----------------------------------------------------------------\n"
 	"o The line 'Type:' shows the type of the configuration option for\n"
-	"  this symbol (boolean, tristate, string, ...)\n"
+	"  this symbol (bool, tristate, string, ...)\n"
 	"o The line 'Prompt:' shows the text used in the menu structure for\n"
 	"  this symbol\n"
 	"o The 'Defined at' line tells at what file / line number the symbol\n"
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index a26cc5d..f3594fa 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -256,14 +256,14 @@ static void sym_check_prop(struct symbol *sym)
 			if (sym->type != S_BOOLEAN && sym->type != S_TRISTATE)
 				prop_warn(prop,
 				    "config symbol '%s' uses select, but is "
-				    "not boolean or tristate", sym->name);
+				    "neither bool nor tristate", sym->name);
 			else if (sym2->type != S_UNKNOWN &&
 				 sym2->type != S_BOOLEAN &&
 				 sym2->type != S_TRISTATE)
 				prop_warn(prop,
 				    "'%s' has wrong type. 'select' only "
-				    "accept arguments of boolean and "
-				    "tristate type", sym2->name);
+				    "accepts arguments of type bool and "
+				    "tristate", sym2->name);
 			break;
 		case P_RANGE:
 			if (sym->type != S_INT && sym->type != S_HEX)
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 7caabdb..d855325 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -77,7 +77,7 @@ const char *sym_type_name(enum symbol_type type)
 {
 	switch (type) {
 	case S_BOOLEAN:
-		return "boolean";
+		return "bool";
 	case S_TRISTATE:
 		return "tristate";
 	case S_INT:
diff --git a/scripts/kconfig/zconf.gperf b/scripts/kconfig/zconf.gperf
index b6ac02d..d8fcf97 100644
--- a/scripts/kconfig/zconf.gperf
+++ b/scripts/kconfig/zconf.gperf
@@ -31,7 +31,6 @@ prompt,		T_PROMPT,	TF_COMMAND
 tristate,	T_TYPE,		TF_COMMAND, S_TRISTATE
 def_tristate,	T_DEFAULT,	TF_COMMAND, S_TRISTATE
 bool,		T_TYPE,		TF_COMMAND, S_BOOLEAN
-boolean,	T_TYPE,		TF_COMMAND, S_BOOLEAN
 def_bool,	T_DEFAULT,	TF_COMMAND, S_BOOLEAN
 int,		T_TYPE,		TF_COMMAND, S_INT
 hex,		T_TYPE,		TF_COMMAND, S_HEX
diff --git a/scripts/kconfig/zconf.hash.c_shipped b/scripts/kconfig/zconf.hash.c_shipped
index c77a8ef..c29b2a3 100644
--- a/scripts/kconfig/zconf.hash.c_shipped
+++ b/scripts/kconfig/zconf.hash.c_shipped
@@ -55,7 +55,7 @@ kconf_id_hash (register const char *str, register unsigned int len)
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73,  5, 25, 25,
+      73, 73, 73, 73, 73, 73, 73,  5,  5, 25,
        0,  0,  0,  5,  0,  0, 73, 73,  5,  0,
       10,  5, 45, 73, 20, 20,  0, 15, 15, 73,
       20,  5, 73, 73, 73, 73, 73, 73, 73, 73,
@@ -101,6 +101,7 @@ struct kconf_id_strings_t
     char kconf_id_strings_str14[sizeof("defconfig_list")];
     char kconf_id_strings_str17[sizeof("on")];
     char kconf_id_strings_str18[sizeof("optional")];
+    char kconf_id_strings_str19[sizeof("bool")];
     char kconf_id_strings_str21[sizeof("option")];
     char kconf_id_strings_str22[sizeof("endmenu")];
     char kconf_id_strings_str23[sizeof("mainmenu")];
@@ -113,12 +114,10 @@ struct kconf_id_strings_t
     char kconf_id_strings_str33[sizeof("env")];
     char kconf_id_strings_str35[sizeof("range")];
     char kconf_id_strings_str36[sizeof("choice")];
-    char kconf_id_strings_str39[sizeof("bool")];
     char kconf_id_strings_str41[sizeof("source")];
     char kconf_id_strings_str42[sizeof("visible")];
     char kconf_id_strings_str43[sizeof("hex")];
     char kconf_id_strings_str46[sizeof("config")];
-    char kconf_id_strings_str47[sizeof("boolean")];
     char kconf_id_strings_str51[sizeof("string")];
     char kconf_id_strings_str54[sizeof("help")];
     char kconf_id_strings_str56[sizeof("prompt")];
@@ -137,6 +136,7 @@ static const struct kconf_id_strings_t kconf_id_strings_contents =
     "defconfig_list",
     "on",
     "optional",
+    "bool",
     "option",
     "endmenu",
     "mainmenu",
@@ -149,12 +149,10 @@ static const struct kconf_id_strings_t kconf_id_strings_contents =
     "env",
     "range",
     "choice",
-    "bool",
     "source",
     "visible",
     "hex",
     "config",
-    "boolean",
     "string",
     "help",
     "prompt",
@@ -172,7 +170,7 @@ kconf_id_lookup (register const char *str, register unsigned int len)
 {
   enum
     {
-      TOTAL_KEYWORDS = 33,
+      TOTAL_KEYWORDS = 32,
       MIN_WORD_LENGTH = 2,
       MAX_WORD_LENGTH = 14,
       MIN_HASH_VALUE = 2,
@@ -184,7 +182,7 @@ kconf_id_lookup (register const char *str, register unsigned int len)
       {-1}, {-1},
 #line 25 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str2,		T_IF,		TF_COMMAND|TF_PARAM},
-#line 36 "scripts/kconfig/zconf.gperf"
+#line 35 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str3,		T_TYPE,		TF_COMMAND, S_INT},
       {-1},
 #line 26 "scripts/kconfig/zconf.gperf"
@@ -199,17 +197,19 @@ kconf_id_lookup (register const char *str, register unsigned int len)
       {-1}, {-1},
 #line 32 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str12,	T_DEFAULT,	TF_COMMAND, S_TRISTATE},
-#line 35 "scripts/kconfig/zconf.gperf"
+#line 34 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str13,	T_DEFAULT,	TF_COMMAND, S_BOOLEAN},
-#line 45 "scripts/kconfig/zconf.gperf"
+#line 44 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str14,	T_OPT_DEFCONFIG_LIST,TF_OPTION},
       {-1}, {-1},
-#line 43 "scripts/kconfig/zconf.gperf"
+#line 42 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str17,		T_ON,		TF_PARAM},
 #line 28 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,	T_OPTIONAL,	TF_COMMAND},
-      {-1}, {-1},
-#line 42 "scripts/kconfig/zconf.gperf"
+#line 33 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str19,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {-1},
+#line 41 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str21,		T_OPTION,	TF_COMMAND},
 #line 17 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str22,	T_ENDMENU,	TF_COMMAND},
@@ -219,41 +219,36 @@ kconf_id_lookup (register const char *str, register unsigned int len)
 #line 23 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str25,	T_MENUCONFIG,	TF_COMMAND},
       {-1},
-#line 44 "scripts/kconfig/zconf.gperf"
+#line 43 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str27,	T_OPT_MODULES,	TF_OPTION},
-#line 47 "scripts/kconfig/zconf.gperf"
+#line 46 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str28,	T_OPT_ALLNOCONFIG_Y,TF_OPTION},
 #line 16 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str29,		T_MENU,		TF_COMMAND},
       {-1},
-#line 39 "scripts/kconfig/zconf.gperf"
+#line 38 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str31,		T_SELECT,	TF_COMMAND},
 #line 21 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str32,	T_COMMENT,	TF_COMMAND},
-#line 46 "scripts/kconfig/zconf.gperf"
+#line 45 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str33,		T_OPT_ENV,	TF_OPTION},
       {-1},
-#line 40 "scripts/kconfig/zconf.gperf"
+#line 39 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str35,		T_RANGE,	TF_COMMAND},
 #line 19 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str36,		T_CHOICE,	TF_COMMAND},
-      {-1}, {-1},
-#line 33 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str39,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
-      {-1},
+      {-1}, {-1}, {-1}, {-1},
 #line 18 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str41,		T_SOURCE,	TF_COMMAND},
-#line 41 "scripts/kconfig/zconf.gperf"
+#line 40 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str42,	T_VISIBLE,	TF_COMMAND},
-#line 37 "scripts/kconfig/zconf.gperf"
+#line 36 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str43,		T_TYPE,		TF_COMMAND, S_HEX},
       {-1}, {-1},
 #line 22 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str46,		T_CONFIG,	TF_COMMAND},
-#line 34 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str47,	T_TYPE,		TF_COMMAND, S_BOOLEAN},
-      {-1}, {-1}, {-1},
-#line 38 "scripts/kconfig/zconf.gperf"
+      {-1}, {-1}, {-1}, {-1},
+#line 37 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str51,		T_TYPE,		TF_COMMAND, S_STRING},
       {-1}, {-1},
 #line 24 "scripts/kconfig/zconf.gperf"
@@ -285,5 +280,5 @@ kconf_id_lookup (register const char *str, register unsigned int len)
     }
   return 0;
 }
-#line 48 "scripts/kconfig/zconf.gperf"
+#line 47 "scripts/kconfig/zconf.gperf"
 
diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index 0864c7d..acdf6e3 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -2290,7 +2290,7 @@ static void print_symbol(FILE *out, struct menu *menu)
 		fprintf(out, "\nconfig %s\n", sym->name);
 	switch (sym->type) {
 	case S_BOOLEAN:
-		fputs("  boolean\n", out);
+		fputs("  bool\n", out);
 		break;
 	case S_TRISTATE:
 		fputs("  tristate\n", out);
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 0f683cf..adb8828 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -607,7 +607,7 @@ static void print_symbol(FILE *out, struct menu *menu)
 		fprintf(out, "\nconfig %s\n", sym->name);
 	switch (sym->type) {
 	case S_BOOLEAN:
-		fputs("  boolean\n", out);
+		fputs("  bool\n", out);
 		break;
 	case S_TRISTATE:
 		fputs("  tristate\n", out);
diff --git a/security/integrity/Kconfig b/security/integrity/Kconfig
index b76235a..73c457b 100644
--- a/security/integrity/Kconfig
+++ b/security/integrity/Kconfig
@@ -16,7 +16,7 @@ config INTEGRITY
 if INTEGRITY
 
 config INTEGRITY_SIGNATURE
-	boolean "Digital signature verification using multiple keyrings"
+	bool "Digital signature verification using multiple keyrings"
 	depends on KEYS
 	default n
 	select SIGNATURE
@@ -30,7 +30,7 @@ config INTEGRITY_SIGNATURE
 	  usually only added from initramfs.
 
 config INTEGRITY_ASYMMETRIC_KEYS
-	boolean "Enable asymmetric keys support"
+	bool "Enable asymmetric keys support"
 	depends on INTEGRITY_SIGNATURE
 	default n
         select ASYMMETRIC_KEY_TYPE
diff --git a/security/integrity/evm/Kconfig b/security/integrity/evm/Kconfig
index df586fa..bf19723 100644
--- a/security/integrity/evm/Kconfig
+++ b/security/integrity/evm/Kconfig
@@ -1,5 +1,5 @@
 config EVM
-	boolean "EVM support"
+	bool "EVM support"
 	select KEYS
 	select ENCRYPTED_KEYS
 	select CRYPTO_HMAC
-- 
2.1.0

