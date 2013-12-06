Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161066Ab3LFQth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 11:49:37 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:51876 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3LFQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 11:49:34 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH v2 02/11] arm: pxa27x: support ICP DAS LP-8x4x
Date: Fri,  6 Dec 2013 20:48:58 +0400
Message-Id: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385879185-22455-3-git-send-email-ynvich@gmail.com>
References: <1385879185-22455-3-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ICP DAS calls LP-8x4x 'programmable automation controller'. It is
an industrial computer based on PXA270 SoC. They ship it with a 2.6.19
kernel and proprietary kernel module and userspace library to access
its industrial IO.

This patch allows to boot the device with a modern kernel. It adds
support for:
* FPGA irq chip
* MMC card interface on PXA270
* USB 1.1 port on PXA270
* 2 NOR flash devices
* VGA interface on PXA270
* 2 onboard ethernet Davicom DM9000 devices
* 3 serial UART ports on PXA270

Support for these devices will be added in separate patches, since
they are not currently supported by the kernel:
* DS1302 RTC
* 512kiB SRAM
* 3 built-in and up to 32 pluggable 8250 serial UART ports
* industrial IO parallel bus
* digital and analog industrial IO modules for parallel bus
* serial interface for digital and analog industrial IO modules on
  parallel bus

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
 changes v1..v2
 * clean up defconfig (reduces size by 10) as suggested 
   by Arnd Bergmann

 * fixed constant address definition to include (void *) cast
   as suggested by Arnd Bergmann

 * moved fixed virtual addresses into the machine source file.
   Header file is dropped.

 * static platform devices are replaced by dynamically allocated
   as suggested by Arnd Bergmann

 arch/arm/configs/lp8x4x_defconfig | 235 +++++++++++++++++++
 arch/arm/mach-pxa/Kconfig         |  16 ++
 arch/arm/mach-pxa/Makefile        |   1 +
 arch/arm/mach-pxa/lp8x4x.c        | 473 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 725 insertions(+)
 create mode 100644 arch/arm/configs/lp8x4x_defconfig
 create mode 100644 arch/arm/mach-pxa/lp8x4x.c

diff --git a/arch/arm/configs/lp8x4x_defconfig b/arch/arm/configs/lp8x4x_defconfig
new file mode 100644
index 0000000..2612e60
--- /dev/null
+++ b/arch/arm/configs/lp8x4x_defconfig
@@ -0,0 +1,235 @@
+CONFIG_CROSS_COMPILE="arm-linux-gnueabi-"
+# CONFIG_LOCALVERSION_AUTO is not set
+# CONFIG_SWAP is not set
+CONFIG_SYSVIPC=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_RCU_BOOST=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_NAMESPACES=y
+# CONFIG_UTS_NS is not set
+# CONFIG_IPC_NS is not set
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+# CONFIG_UID16 is not set
+# CONFIG_SHMEM is not set
+CONFIG_EMBEDDED=y
+# CONFIG_COMPAT_BRK is not set
+CONFIG_SLOB=y
+CONFIG_JUMP_LABEL=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_MODVERSIONS=y
+# CONFIG_LBDAF is not set
+CONFIG_BLK_CMDLINE_PARSER=y
+CONFIG_PARTITION_ADVANCED=y
+CONFIG_BSD_DISKLABEL=y
+CONFIG_MINIX_SUBPARTITION=y
+CONFIG_SOLARIS_X86_PARTITION=y
+CONFIG_UNIXWARE_DISKLABEL=y
+CONFIG_LDM_PARTITION=y
+# CONFIG_EFI_PARTITION is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_ARCH_PXA=y
+CONFIG_MACH_LP8X4X=y
+# CONFIG_ARM_THUMB is not set
+CONFIG_PREEMPT=y
+CONFIG_AEABI=y
+# CONFIG_COMPACTION is not set
+# CONFIG_CROSS_MEMORY_ATTACH is not set
+CONFIG_ZBOOT_ROM_TEXT=0x0
+CONFIG_ZBOOT_ROM_BSS=0x0
+CONFIG_CMDLINE="init=/sbin/init root=/dev/mmcblk0p1 rw rootfstype=ext4 console=ttyS0,115200 mem=128M rootwait"
+# CONFIG_SUSPEND is not set
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_BOOTP=y
+CONFIG_BRIDGE=m
+CONFIG_BRIDGE_VLAN_FILTERING=y
+CONFIG_VLAN_8021Q=m
+CONFIG_VLAN_8021Q_GVRP=y
+CONFIG_VLAN_8021Q_MVRP=y
+# CONFIG_WIRELESS is not set
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_FW_LOADER is not set
+CONFIG_MTD=y
+CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_BLOCK=y
+CONFIG_MTD_CFI=y
+CONFIG_MTD_CFI_ADV_OPTIONS=y
+CONFIG_MTD_CFI_GEOMETRY=y
+CONFIG_MTD_CFI_INTELEXT=y
+CONFIG_MTD_PXA2XX=y
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_BLK_DEV_LOOP_MIN_COUNT=2
+CONFIG_SCSI=y
+# CONFIG_SCSI_PROC_FS is not set
+CONFIG_BLK_DEV_SD=y
+# CONFIG_SCSI_LOWLEVEL is not set
+CONFIG_NETDEVICES=y
+CONFIG_BONDING=m
+CONFIG_MACVLAN=m
+CONFIG_MACVTAP=m
+CONFIG_TUN=m
+# CONFIG_NET_VENDOR_ARC is not set
+# CONFIG_NET_CADENCE is not set
+# CONFIG_NET_VENDOR_BROADCOM is not set
+# CONFIG_NET_VENDOR_CIRRUS is not set
+CONFIG_DM9000=y
+CONFIG_DM9000_FORCE_SIMPLE_PHY_POLL=y
+# CONFIG_NET_VENDOR_FARADAY is not set
+# CONFIG_NET_VENDOR_INTEL is not set
+# CONFIG_NET_VENDOR_MARVELL is not set
+# CONFIG_NET_VENDOR_MICREL is not set
+# CONFIG_NET_VENDOR_NATSEMI is not set
+# CONFIG_NET_VENDOR_SEEQ is not set
+# CONFIG_NET_VENDOR_SMSC is not set
+# CONFIG_NET_VENDOR_STMICRO is not set
+# CONFIG_NET_VENDOR_VIA is not set
+# CONFIG_NET_VENDOR_WIZNET is not set
+CONFIG_PPP=m
+CONFIG_PPP_BSDCOMP=m
+CONFIG_PPP_DEFLATE=m
+CONFIG_PPPOE=m
+CONFIG_PPP_ASYNC=m
+CONFIG_PPP_SYNC_TTY=m
+CONFIG_SLIP=m
+CONFIG_SLIP_COMPRESSED=y
+# CONFIG_WLAN is not set
+CONFIG_INPUT_MOUSEDEV_SCREEN_X=800
+CONFIG_INPUT_MOUSEDEV_SCREEN_Y=600
+CONFIG_INPUT_EVDEV=y
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_SERIO is not set
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_8250=y
+# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_NR_UARTS=40
+CONFIG_SERIAL_8250_RUNTIME_UARTS=40
+CONFIG_SERIAL_8250_EXTENDED=y
+CONFIG_SERIAL_8250_MANY_PORTS=y
+CONFIG_SERIAL_8250_SHARE_IRQ=y
+CONFIG_SERIAL_PXA=y
+CONFIG_HW_RANDOM=y
+CONFIG_I2C=m
+# CONFIG_I2C_COMPAT is not set
+CONFIG_I2C_PXA=m
+CONFIG_I2C_PXA_SLAVE=y
+# CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+CONFIG_SA1100_WATCHDOG=m
+CONFIG_FB=y
+CONFIG_FB_PXA=y
+CONFIG_FRAMEBUFFER_CONSOLE=y
+CONFIG_LOGO=y
+CONFIG_HID_GENERIC=m
+CONFIG_HID_A4TECH=m
+CONFIG_HID_CYPRESS=m
+CONFIG_HID_KEYTOUCH=m
+CONFIG_HID_KENSINGTON=m
+CONFIG_HID_LOGITECH=m
+CONFIG_HID_MICROSOFT=m
+CONFIG_HID_MONTEREY=m
+CONFIG_USB_HIDDEV=y
+CONFIG_I2C_HID=m
+CONFIG_USB=m
+CONFIG_USB_OHCI_HCD=m
+CONFIG_USB_ACM=m
+CONFIG_USB_PRINTER=m
+CONFIG_USB_STORAGE=m
+CONFIG_USB_STORAGE_REALTEK=m
+CONFIG_USB_STORAGE_DATAFAB=m
+CONFIG_USB_STORAGE_FREECOM=m
+CONFIG_USB_STORAGE_ISD200=m
+CONFIG_USB_STORAGE_USBAT=m
+CONFIG_USB_STORAGE_SDDR09=m
+CONFIG_USB_STORAGE_SDDR55=m
+CONFIG_USB_STORAGE_JUMPSHOT=m
+CONFIG_USB_STORAGE_ALAUDA=m
+CONFIG_USB_STORAGE_ONETOUCH=m
+CONFIG_USB_STORAGE_KARMA=m
+CONFIG_USB_STORAGE_CYPRESS_ATACB=m
+CONFIG_USB_STORAGE_ENE_UB6250=m
+CONFIG_USB_SERIAL=m
+CONFIG_USB_SERIAL_GENERIC=y
+CONFIG_USB_SERIAL_SIMPLE=m
+CONFIG_USB_SERIAL_AIRCABLE=m
+CONFIG_USB_SERIAL_ARK3116=m
+CONFIG_USB_SERIAL_BELKIN=m
+CONFIG_USB_SERIAL_CH341=m
+CONFIG_USB_SERIAL_WHITEHEAT=m
+CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
+CONFIG_USB_SERIAL_CP210X=m
+CONFIG_USB_SERIAL_CYPRESS_M8=m
+CONFIG_USB_SERIAL_EMPEG=m
+CONFIG_USB_SERIAL_FTDI_SIO=m
+CONFIG_USB_SERIAL_VISOR=m
+CONFIG_USB_SERIAL_IPAQ=m
+CONFIG_USB_SERIAL_IR=m
+CONFIG_USB_SERIAL_EDGEPORT=m
+CONFIG_USB_SERIAL_EDGEPORT_TI=m
+CONFIG_USB_SERIAL_F81232=m
+CONFIG_USB_SERIAL_GARMIN=m
+CONFIG_USB_SERIAL_IPW=m
+CONFIG_USB_SERIAL_IUU=m
+CONFIG_USB_SERIAL_KEYSPAN_PDA=m
+CONFIG_USB_SERIAL_KEYSPAN=m
+CONFIG_USB_SERIAL_KLSI=m
+CONFIG_USB_SERIAL_KOBIL_SCT=m
+CONFIG_USB_SERIAL_MCT_U232=m
+CONFIG_USB_SERIAL_METRO=m
+CONFIG_USB_SERIAL_MOS7720=m
+CONFIG_USB_SERIAL_MOS7840=m
+CONFIG_USB_SERIAL_NAVMAN=m
+CONFIG_USB_SERIAL_PL2303=m
+CONFIG_USB_SERIAL_OTI6858=m
+CONFIG_USB_SERIAL_QCAUX=m
+CONFIG_USB_SERIAL_QUALCOMM=m
+CONFIG_USB_SERIAL_SPCP8X5=m
+CONFIG_USB_SERIAL_SAFE=m
+CONFIG_USB_SERIAL_SAFE_PADDED=y
+CONFIG_USB_SERIAL_SIERRAWIRELESS=m
+CONFIG_USB_SERIAL_SYMBOL=m
+CONFIG_USB_SERIAL_TI=m
+CONFIG_USB_SERIAL_CYBERJACK=m
+CONFIG_USB_SERIAL_XIRCOM=m
+CONFIG_USB_SERIAL_OPTION=m
+CONFIG_USB_SERIAL_OMNINET=m
+CONFIG_USB_SERIAL_OPTICON=m
+CONFIG_USB_SERIAL_XSENS_MT=m
+CONFIG_USB_SERIAL_WISHBONE=m
+CONFIG_USB_SERIAL_ZTE=m
+CONFIG_USB_SERIAL_SSU100=m
+CONFIG_USB_SERIAL_QT2=m
+CONFIG_MMC=y
+CONFIG_MMC_PXA=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_PXA=m
+# CONFIG_IOMMU_SUPPORT is not set
+CONFIG_EXT2_FS=m
+CONFIG_EXT3_FS=y
+CONFIG_EXT4_FS=y
+CONFIG_REISERFS_FS=m
+CONFIG_ISO9660_FS=m
+CONFIG_MSDOS_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_NTFS_FS=m
+CONFIG_NTFS_RW=y
+CONFIG_JFFS2_FS=y
+CONFIG_JFFS2_COMPRESSION_OPTIONS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V4=y
+CONFIG_ROOT_NFS=y
+CONFIG_CIFS=m
+CONFIG_CIFS_STATS=y
+CONFIG_CODA_FS=m
+CONFIG_NLS_DEFAULT="cp1251"
+CONFIG_NLS_CODEPAGE_1251=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_NLS_UTF8=y
+CONFIG_PRINTK_TIME=y
diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 96100db..efaf2d0 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -273,6 +273,22 @@ config MACH_VPAC270
 
 comment "End-user Products (sorted by vendor name)"
 
+config MACH_LP8X4X
+	bool "ICP DAS LP-8X4X"
+	select IWMMXT
+	select PXA27x
+	help
+	  Say Y here if you intend to run this kernel on an ICP DAS
+	  LP-8x4x programmable automation controller.
+
+	  LP-8x4x is ARM-based and built around PXA270 SoC. The device
+	  has 128 MiB SDRAM, 48 or 96 MiB NOR flash, VGA port with
+	  800x600 resolution, MMC card slot, 2 Ethernet ports, 1 USB
+	  port, 5 serial ports (1 on them is wired internally to
+	  expansion slots). The device has a range of digital and
+	  analog expansion IO modules which can be installed in 1, 4 or
+	  8 slots depending on the model.
+
 config MACH_H4700
 	bool "HP iPAQ hx4700"
 	select HAVE_PWM
diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 648867a..b264325 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_MACH_COLIBRI320)	+= colibri-pxa3xx.o colibri-pxa320.o
 obj-$(CONFIG_MACH_VPAC270)	+= vpac270.o
 
 # End-user Products
+obj-$(CONFIG_MACH_LP8X4X)	+= lp8x4x.o
 obj-$(CONFIG_MACH_H4700)	+= hx4700.o
 obj-$(CONFIG_MACH_H5000)	+= h5000.o
 obj-$(CONFIG_MACH_HIMALAYA)	+= himalaya.o
diff --git a/arch/arm/mach-pxa/lp8x4x.c b/arch/arm/mach-pxa/lp8x4x.c
new file mode 100644
index 0000000..0d3d8c0
--- /dev/null
+++ b/arch/arm/mach-pxa/lp8x4x.c
@@ -0,0 +1,473 @@
+/*
+ *  linux/arch/arm/mach-pxa/lp8x4x.c
+ *
+ *  Support for ICP DAS LP-8x4x programmable automation controller
+ *  Copyright (C) 2013 Sergei Ianovich <ynvich@gmail.com>
+ *
+ *  borrowed heavily from
+ *  Support for the Intel HCDDBBVA0 Development Platform.
+ *
+ *  Author:	Nicolas Pitre
+ *  Created:	Nov 05, 2002
+ *  Copyright:	MontaVista Software Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation or any later version.
+ */
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/syscore_ops.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/bitops.h>
+#include <linux/fb.h>
+#include <linux/ioport.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/input.h>
+#include <linux/dm9000.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
+#include <linux/ktime.h>
+#include <linux/irqchip/chained_irq.h>
+
+#include <asm/types.h>
+#include <asm/setup.h>
+#include <asm/memory.h>
+#include <asm/mach-types.h>
+#include <mach/hardware.h>
+#include <asm/irq.h>
+#include <asm/sizes.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/mach/flash.h>
+
+#include <mach/irqs.h>
+#include <mach/pxa27x.h>
+#include <linux/platform_data/video-pxafb.h>
+#include <linux/platform_data/mmc-pxamci.h>
+#include <linux/platform_data/usb-ohci-pxa27x.h>
+#include <mach/smemc.h>
+
+#include "generic.h"
+#include "devices.h"
+
+#define LP8X4X_ETH0_BASE        0x0c000000
+#define LP8X4X_ETH0_IO          0x0c004000
+#define LP8X4X_ETH0_IRQ         PXA_GPIO_TO_IRQ(9)
+
+#define LP8X4X_ETH1_BASE        0x0d000000
+#define LP8X4X_ETH1_IO          0x0d004000
+#define LP8X4X_ETH1_IRQ         PXA_GPIO_TO_IRQ(82)
+
+#define LP8X4X_FPGA_PHYS	0x17000000
+#define LP8X4X_FPGA_VIRT	((void *) 0xf1000000)
+#define LP8X4X_P2V(x)		IOMEM((x) - LP8X4X_FPGA_PHYS + LP8X4X_FPGA_VIRT)
+#define LP8X4X_V2P(x)		((x) - LP8X4X_FPGA_VIRT + LP8X4X_FPGA_PHYS)
+
+/* board level registers in the FPGA */
+
+#define LP8X4X_EOI		LP8X4X_P2V(0x17009006)
+#define LP8X4X_INSINT		LP8X4X_P2V(0x17009008)
+#define LP8X4X_ENSYSINT		LP8X4X_P2V(0x1700900A)
+#define LP8X4X_PRIMINT		LP8X4X_P2V(0x1700900C)
+#define LP8X4X_SECOINT		LP8X4X_P2V(0x1700900E)
+#define LP8X4X_ENRISEINT	LP8X4X_P2V(0x17009010)
+#define LP8X4X_CLRRISEINT	LP8X4X_P2V(0x17009012)
+#define LP8X4X_ENHILVINT	LP8X4X_P2V(0x17009014)
+#define LP8X4X_CLRHILVINT	LP8X4X_P2V(0x17009016)
+#define LP8X4X_ENFALLINT	LP8X4X_P2V(0x17009018)
+#define LP8X4X_CLRFALLINT	LP8X4X_P2V(0x1700901a)
+
+/* board specific IRQs */
+
+#define LP8X4X_IRQ(x)		(IRQ_BOARD_START + (x))
+#define LP8X4X_SLOT1_IRQ	LP8X4X_IRQ(0)
+#define LP8X4X_SLOT2_IRQ	LP8X4X_IRQ(1)
+#define LP8X4X_SLOT3_IRQ	LP8X4X_IRQ(2)
+#define LP8X4X_SLOT4_IRQ	LP8X4X_IRQ(3)
+#define LP8X4X_SLOT5_IRQ	LP8X4X_IRQ(4)
+#define LP8X4X_SLOT6_IRQ	LP8X4X_IRQ(5)
+#define LP8X4X_SLOT7_IRQ	LP8X4X_IRQ(6)
+#define LP8X4X_SLOT8_IRQ	LP8X4X_IRQ(7)
+#define LP8X4X_TIMER1_IRQ	LP8X4X_IRQ(8)
+#define LP8X4X_TIMER2_IRQ	LP8X4X_IRQ(9)
+#define LP8X4X_TIMEROUT_IRQ	LP8X4X_IRQ(10)
+#define LP8X4X_HOTPLUG_IRQ	LP8X4X_IRQ(11)
+#define LP8X4X_BATLOW_IRQ	LP8X4X_IRQ(12)
+#define LP8X4X_TTYS0_IRQ	LP8X4X_IRQ(13)
+#define LP8X4X_TTYS1_IRQ	LP8X4X_IRQ(14)
+#define LP8X4X_TTYS2_IRQ	LP8X4X_IRQ(15)
+
+#define LP8X4X_NR_IRQS		(IRQ_BOARD_START + 16)
+
+static unsigned char lp8x4x_irq_sys_enabled;
+static unsigned char lp8x4x_irq_high_enabled;
+
+static void lp8x4x_ack_irq(struct irq_data *d)
+{
+	unsigned mask;
+	int irq = d->irq - IRQ_BOARD_START;
+
+	if (irq < 0 || irq > 15) {
+		pr_err("lp8x4x: wrong irq handler for irq %i\n", d->irq);
+		return;
+	}
+
+	if (irq < 8) {
+		mask = ioread8(LP8X4X_CLRHILVINT);
+		mask |= 1 << irq;
+		iowrite8(mask, LP8X4X_CLRHILVINT);
+	} else if (irq < 13) {
+		irq -= 8;
+		mask = ioread8(LP8X4X_SECOINT);
+		mask |= 1 << irq;
+		iowrite8(mask, LP8X4X_SECOINT);
+	} else {
+		irq -= 8;
+		mask = ioread8(LP8X4X_PRIMINT);
+		mask |= 1 << irq;
+		iowrite8(mask, LP8X4X_PRIMINT);
+	}
+}
+
+static void lp8x4x_mask_irq(struct irq_data *d)
+{
+	int irq = d->irq - IRQ_BOARD_START;
+
+	if (irq < 0 || irq > 15) {
+		pr_err("lp8x4x: wrong irq handler for irq %i\n", d->irq);
+		return;
+	}
+
+	if (irq < 8) {
+		lp8x4x_irq_high_enabled &= ~(1 << irq);
+		iowrite8(lp8x4x_irq_high_enabled, LP8X4X_ENHILVINT);
+	} else {
+		irq -= 8;
+		lp8x4x_irq_sys_enabled &= ~(1 << irq);
+		iowrite8(lp8x4x_irq_sys_enabled, LP8X4X_ENSYSINT);
+	}
+}
+
+static void lp8x4x_unmask_irq(struct irq_data *d)
+{
+	unsigned mask;
+	int irq = d->irq - IRQ_BOARD_START;
+
+	if (irq < 0 || irq > 15) {
+		pr_err("wrong irq handler for irq %i\n", d->irq);
+		return;
+	}
+
+	if (irq < 8) {
+		lp8x4x_irq_high_enabled |= 1 << irq;
+		mask = ioread8(LP8X4X_CLRHILVINT);
+		mask |= 1 << irq;
+		iowrite8(mask, LP8X4X_CLRHILVINT);
+		iowrite8(lp8x4x_irq_high_enabled, LP8X4X_ENHILVINT);
+	} else if (irq < 13) {
+		irq -= 8;
+		lp8x4x_irq_sys_enabled |= 1 << irq;
+		mask = ioread8(LP8X4X_SECOINT);
+		mask |= 1 << irq;
+		iowrite8(mask, LP8X4X_SECOINT);
+		iowrite8(lp8x4x_irq_sys_enabled, LP8X4X_ENSYSINT);
+	} else {
+		irq -= 8;
+		lp8x4x_irq_sys_enabled |= 1 << irq;
+		mask = ioread8(LP8X4X_PRIMINT);
+		mask |= 1 << irq;
+		iowrite8(mask, LP8X4X_PRIMINT);
+		iowrite8(lp8x4x_irq_sys_enabled, LP8X4X_ENSYSINT);
+	}
+}
+
+static struct irq_chip lp8x4x_irq_chip = {
+	.name			= "FPGA",
+	.irq_ack		= lp8x4x_ack_irq,
+	.irq_mask		= lp8x4x_mask_irq,
+	.irq_unmask		= lp8x4x_unmask_irq,
+};
+
+static spinlock_t fpga_irq_lock;
+
+static void lp8x4x_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	int loop, n;
+	unsigned long mask;
+	unsigned long flags;
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+
+	spin_lock_irqsave(&fpga_irq_lock, flags);
+	chained_irq_enter(chip, desc);
+
+	do {
+		loop = 0;
+		mask = ioread8(LP8X4X_CLRHILVINT) & 0xff;
+		mask |= (ioread8(LP8X4X_SECOINT) & 0x1f) << 8;
+		mask |= (ioread8(LP8X4X_PRIMINT) & 0xe0) << 8;
+		mask &= (lp8x4x_irq_high_enabled
+				| (lp8x4x_irq_sys_enabled << 8));
+		for_each_set_bit(n, &mask, BITS_PER_LONG) {
+			loop = 1;
+
+			generic_handle_irq(IRQ_BOARD_START + n);
+		}
+	} while (loop);
+
+	chained_irq_exit(chip, desc);
+	iowrite8(0, LP8X4X_EOI);
+	spin_unlock_irqrestore(&fpga_irq_lock, flags);
+}
+
+static void __init lp8x4x_init_irq(void)
+{
+	int irq;
+	int err;
+
+	err = irq_set_irq_type(PXA_GPIO_TO_IRQ(3), IRQ_TYPE_EDGE_RISING);
+	if (err < 0) {
+		pr_err("lp8x4x: irq init failed\n");
+		return;
+	}
+
+	spin_lock_init(&fpga_irq_lock);
+	irq_set_chained_handler(PXA_GPIO_TO_IRQ(3), lp8x4x_irq_handler);
+
+	for (irq = IRQ_BOARD_START; irq < LP8X4X_NR_IRQS; irq++) {
+		irq_set_chip_and_handler(irq, &lp8x4x_irq_chip,
+					 handle_level_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+	}
+
+	iowrite8(0, LP8X4X_CLRRISEINT);
+	iowrite8(0, LP8X4X_ENRISEINT);
+	iowrite8(0, LP8X4X_CLRFALLINT);
+	iowrite8(0, LP8X4X_ENFALLINT);
+	iowrite8(0, LP8X4X_CLRHILVINT);
+	iowrite8(0, LP8X4X_ENHILVINT);
+	iowrite8(0, LP8X4X_ENSYSINT);
+	iowrite8(0, LP8X4X_PRIMINT);
+	iowrite8(0, LP8X4X_SECOINT);
+
+	return;
+}
+
+static unsigned long lp8x4x_pin_config[] = {
+	/* MMC */
+	GPIO32_MMC_CLK,
+	GPIO112_MMC_CMD,
+	GPIO92_MMC_DAT_0,
+	GPIO109_MMC_DAT_1,
+	GPIO110_MMC_DAT_2,
+	GPIO111_MMC_DAT_3,
+
+	/* USB Host Port 1 */
+	GPIO88_USBH1_PWR,
+	GPIO89_USBH1_PEN,
+};
+
+static struct resource lp8x4x_flash_resources[] __initdata = {
+	[0] = {
+		.start	= PXA_CS0_PHYS,
+		.end	= PXA_CS0_PHYS + SZ_64M - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= PXA_CS1_PHYS,
+		.end	= PXA_CS1_PHYS + SZ_32M - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct mtd_partition lp8x4x_flash0_partitions[] = {
+	{
+		.name =		"Bootloader",
+		.size =		0x00040000,
+		.offset =	0,
+	}, {
+		.name =		"Settings",
+		.size =		0x00040000,
+		.offset =	0x00040000,
+	}, {
+		.name =		"Kernel",
+		.size =		0x00280000,
+		.offset =	0x00080000,
+	}, {
+		.name =		"Filesystem",
+		.size =		MTDPART_SIZ_FULL,
+		.offset =	0x00300000
+	}
+};
+
+static struct flash_platform_data lp8x4x_flash_data[] __initdata = {
+	{
+		.map_name	= "cfi_probe",
+		.parts		= lp8x4x_flash0_partitions,
+		.nr_parts	= ARRAY_SIZE(lp8x4x_flash0_partitions),
+		.width		= 4,
+	}, {
+		.map_name	= "cfi_probe",
+		.parts		= NULL,
+		.nr_parts	= 0,
+		.width		= 2,
+	}
+};
+
+static struct pxafb_mode_info lp8x4x_vga_60_mode = {
+	.pixclock       = 38461,
+	.xres           = 640,
+	.yres           = 480,
+	.bpp            = 16,
+	.hsync_len      = 64,
+	.left_margin    = 78,
+	.right_margin   = 46,
+	.vsync_len      = 12,
+	.upper_margin   = 22,
+	.lower_margin   = 10,
+	.sync           = 0,
+};
+
+static struct pxafb_mach_info lp8x4x_pxafb_info = {
+	.num_modes		= 1,
+	.lccr0			= LCCR0_Act,
+	.lccr3			= LCCR3_PCP,
+};
+
+static int lp8x4x_mci_init(struct device *dev,
+		irq_handler_t mstone_detect_int, void *data)
+{
+	return 0;
+}
+
+static int lp8x4x_mci_setpower(struct device *dev, unsigned int vdd)
+{
+	return 0;
+}
+
+static void lp8x4x_mci_exit(struct device *dev, void *data)
+{
+}
+
+static struct pxamci_platform_data lp8x4x_mci_platform_data = {
+	.ocr_mask		= MMC_VDD_32_33|MMC_VDD_33_34,
+	.init			= lp8x4x_mci_init,
+	.setpower               = lp8x4x_mci_setpower,
+	.exit			= lp8x4x_mci_exit,
+	.gpio_card_detect	= -1,
+	.gpio_card_ro		= -1,
+	.gpio_power		= -1,
+};
+
+static struct resource lp8x4x_dm9000_resources[] __initdata = {
+	[0] = {
+		.start  = LP8X4X_ETH0_BASE,
+		.end    = LP8X4X_ETH0_BASE + 2 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = LP8X4X_ETH0_IO,
+		.end    = LP8X4X_ETH0_IO + 2 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[2] = {
+		.start  = LP8X4X_ETH0_IRQ,
+		.end    = LP8X4X_ETH0_IRQ,
+		.flags	= IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE,
+	},
+	[3] = {
+		.start  = LP8X4X_ETH1_BASE,
+		.end    = LP8X4X_ETH1_BASE + 2 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[4] = {
+		.start  = LP8X4X_ETH1_IO,
+		.end    = LP8X4X_ETH1_IO + 2 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[5] = {
+		.start  = LP8X4X_ETH1_IRQ,
+		.end    = LP8X4X_ETH1_IRQ,
+		.flags	= IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE,
+	},
+};
+
+static struct pxaohci_platform_data lp8x4x_ohci_platform_data = {
+	.port_mode	= PMM_PERPORT_MODE,
+	.flags		= ENABLE_PORT1 | OC_MODE_PERPORT,
+};
+
+static void lp8x4x_restart(enum reboot_mode mode, const char *cmd)
+{
+	/* Switch off fast-bus and turbo mode */
+	asm volatile("mcr       p14, 0, %0, c6, c0, 0" : :
+			"r"(2));
+	/* SDRAM hangs on watchdog reset on Marvell PXA270 (erratum 71) */
+	pxa_restart(REBOOT_SOFT, cmd);
+}
+
+static void __init lp8x4x_init(void)
+{
+	pxa2xx_mfp_config(ARRAY_AND_SIZE(lp8x4x_pin_config));
+
+	pxa_set_ffuart_info(NULL);
+	pxa_set_btuart_info(NULL);
+	pxa_set_stuart_info(NULL);
+
+	/* system bus arbiter setting
+	 * - Core_Park
+	 * - LCD_wt:DMA_wt:CORE_Wt = 2:3:4
+	 */
+	ARB_CNTRL = ARB_CORE_PARK | 0x234;
+
+	pxa_set_mci_info(&lp8x4x_mci_platform_data);
+	pxa_set_ohci_info(&lp8x4x_ohci_platform_data);
+
+	platform_device_register_resndata(NULL, "pxa2xx-flash", 0,
+			&lp8x4x_flash_resources[0], 1,
+			&lp8x4x_flash_data[0], sizeof(lp8x4x_flash_data[0]));
+	platform_device_register_resndata(NULL, "pxa2xx-flash", 1,
+			&lp8x4x_flash_resources[1], 1,
+			&lp8x4x_flash_data[1], sizeof(lp8x4x_flash_data[1]));
+	platform_device_register_simple("dm9000", 0,
+			&lp8x4x_dm9000_resources[0], 3);
+	platform_device_register_simple("dm9000", 1,
+			&lp8x4x_dm9000_resources[3], 3);
+
+	lp8x4x_pxafb_info.modes = &lp8x4x_vga_60_mode;
+	pxa_set_fb_info(NULL, &lp8x4x_pxafb_info);
+
+	/* Could not do this in MACHINE since GPIO is not ready then */
+	lp8x4x_init_irq();
+}
+
+static struct map_desc lp8x4x_io_desc[] __initdata = {
+	{	/* CPLD */
+		.virtual	=  (unsigned long) LP8X4X_FPGA_VIRT,
+		.pfn		= __phys_to_pfn(LP8X4X_FPGA_PHYS),
+		.length		= 0x00100000,
+		.type		= MT_DEVICE
+	}
+};
+
+static void __init lp8x4x_map_io(void)
+{
+	pxa27x_map_io();
+	iotable_init(lp8x4x_io_desc, ARRAY_SIZE(lp8x4x_io_desc));
+}
+
+MACHINE_START(LP8X4X, "ICP DAS LP-8x4x programmable automation controller")
+	.atag_offset	= 0x100,
+	.map_io		= lp8x4x_map_io,
+	.nr_irqs	= LP8X4X_NR_IRQS,
+	.init_irq	= pxa27x_init_irq,
+	.handle_irq	= pxa27x_handle_irq,
+	.init_time	= pxa_timer_init,
+	.init_machine	= lp8x4x_init,
+	.restart	= lp8x4x_restart,
+MACHINE_END
-- 
1.8.4.2

