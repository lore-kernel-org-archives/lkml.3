Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab3LQPjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:39:05 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63721 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3LQPi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:38:59 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, arm@kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, olof@lixom.net,
        soren.brinkmann@xilinx.com, peter.crosthwaite@xilinx.com,
        linux@roeck-us.net, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v5 1/2] ARM: mach-moxart: add MOXA ART SoC platform files
Date: Tue, 17 Dec 2013 16:38:33 +0100
Message-Id: <1387294714-12872-2-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1387294714-12872-1-git-send-email-jonas.jensen@gmail.com>
References: <1387294714-12872-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MOXA ART SoC is based on Faraday's FA526. This is a ARMv4 32-bit
192 MHz CPU with MMU and 16KB/8KB D/I-cache.

Add platform support for this SoC.

Also add UC-7112-LX as a machine.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---
 arch/arm/Kconfig                  |   2 +
 arch/arm/Makefile                 |   1 +
 arch/arm/configs/moxart_defconfig | 149 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-moxart/Kconfig      |  31 ++++++++
 arch/arm/mach-moxart/Makefile     |   3 +
 arch/arm/mach-moxart/moxart.c     |  15 ++++
 6 files changed, 201 insertions(+)
 create mode 100644 arch/arm/configs/moxart_defconfig
 create mode 100644 arch/arm/mach-moxart/Kconfig
 create mode 100644 arch/arm/mach-moxart/Makefile
 create mode 100644 arch/arm/mach-moxart/moxart.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e462c5d..1835956 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -948,6 +948,8 @@ source "arch/arm/mach-ks8695/Kconfig"
 
 source "arch/arm/mach-msm/Kconfig"
 
+source "arch/arm/mach-moxart/Kconfig"
+
 source "arch/arm/mach-mv78xx0/Kconfig"
 
 source "arch/arm/mach-imx/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index aa791d1..35ff8aa 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -167,6 +167,7 @@ machine-$(CONFIG_ARCH_KIRKWOOD)		+= kirkwood
 machine-$(CONFIG_ARCH_KS8695)		+= ks8695
 machine-$(CONFIG_ARCH_LPC32XX)		+= lpc32xx
 machine-$(CONFIG_ARCH_MMP)		+= mmp
+machine-$(CONFIG_ARCH_MOXART)		+= moxart
 machine-$(CONFIG_ARCH_MSM)		+= msm
 machine-$(CONFIG_ARCH_MV78XX0)		+= mv78xx0
 machine-$(CONFIG_ARCH_MVEBU)		+= mvebu
diff --git a/arch/arm/configs/moxart_defconfig b/arch/arm/configs/moxart_defconfig
new file mode 100644
index 0000000..a3cb76c
--- /dev/null
+++ b/arch/arm/configs/moxart_defconfig
@@ -0,0 +1,149 @@
+# CONFIG_LOCALVERSION_AUTO is not set
+# CONFIG_SWAP is not set
+CONFIG_SYSVIPC=y
+CONFIG_NO_HZ=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_SYSCTL_SYSCALL=y
+# CONFIG_ELF_CORE is not set
+# CONFIG_BASE_FULL is not set
+# CONFIG_SIGNALFD is not set
+# CONFIG_TIMERFD is not set
+# CONFIG_EVENTFD is not set
+# CONFIG_AIO is not set
+CONFIG_EMBEDDED=y
+# CONFIG_VM_EVENT_COUNTERS is not set
+# CONFIG_SLUB_DEBUG is not set
+# CONFIG_COMPAT_BRK is not set
+# CONFIG_LBDAF is not set
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_ARCH_MULTI_V4T=y
+# CONFIG_ARCH_MULTI_V7 is not set
+CONFIG_KEYBOARD_GPIO_POLLED=y
+CONFIG_ARCH_MOXART=y
+CONFIG_MACH_UC7112LX=y
+CONFIG_PREEMPT=y
+CONFIG_AEABI=y
+# CONFIG_ATAGS is not set
+CONFIG_ARM_APPENDED_DTB=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_INET_DIAG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_WIRELESS is not set
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_PREVENT_FIRMWARE_BUILD is not set
+# CONFIG_FW_LOADER is not set
+CONFIG_MTD=y
+CONFIG_MTD_BLOCK=y
+CONFIG_MTD_CFI=y
+CONFIG_MTD_CFI_ADV_OPTIONS=y
+CONFIG_MTD_CFI_GEOMETRY=y
+CONFIG_MTD_CFI_INTELEXT=y
+CONFIG_MTD_COMPLEX_MAPPINGS=y
+CONFIG_MTD_PHYSMAP=y
+CONFIG_MTD_PHYSMAP_OF=y
+CONFIG_PROC_DEVICETREE=y
+CONFIG_NETDEVICES=y
+CONFIG_NETCONSOLE=y
+CONFIG_NETCONSOLE_DYNAMIC=y
+# CONFIG_NET_VENDOR_ARC is not set
+# CONFIG_NET_CADENCE is not set
+# CONFIG_NET_VENDOR_BROADCOM is not set
+# CONFIG_NET_VENDOR_CIRRUS is not set
+# CONFIG_NET_VENDOR_FARADAY is not set
+# CONFIG_NET_VENDOR_INTEL is not set
+# CONFIG_NET_VENDOR_MARVELL is not set
+# CONFIG_NET_VENDOR_MICREL is not set
+CONFIG_ARM_MOXART_ETHER=y
+# CONFIG_NET_VENDOR_NATSEMI is not set
+# CONFIG_NET_VENDOR_SEEQ is not set
+# CONFIG_NET_VENDOR_SMSC is not set
+# CONFIG_NET_VENDOR_STMICRO is not set
+# CONFIG_NET_VENDOR_VIA is not set
+# CONFIG_NET_VENDOR_WIZNET is not set
+CONFIG_REALTEK_PHY=y
+CONFIG_MDIO_MOXART=y
+# CONFIG_WLAN is not set
+# CONFIG_INPUT_MOUSEDEV is not set
+CONFIG_INPUT_EVDEV=y
+CONFIG_INPUT_EVBUG=y
+# CONFIG_KEYBOARD_ATKBD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_SERIO is not set
+# CONFIG_VT is not set
+# CONFIG_LEGACY_PTYS is not set
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_NR_UARTS=1
+CONFIG_SERIAL_8250_RUNTIME_UARTS=1
+CONFIG_SERIAL_8250_EXTENDED=y
+CONFIG_SERIAL_8250_SHARE_IRQ=y
+CONFIG_SERIAL_OF_PLATFORM=y
+# CONFIG_HW_RANDOM is not set
+CONFIG_DEBUG_GPIO=y
+CONFIG_GPIO_SYSFS=y
+CONFIG_GPIO_MOXART=y
+CONFIG_POWER_SUPPLY=y
+CONFIG_POWER_RESET=y
+CONFIG_POWER_RESET_GPIO=y
+# CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+CONFIG_WATCHDOG_CORE=y
+CONFIG_WATCHDOG_NOWAYOUT=y
+CONFIG_MOXART_WDT=y
+# CONFIG_USB_SUPPORT is not set
+CONFIG_MMC=y
+CONFIG_MMC_SDHCI_MOXART=y
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_ONESHOT=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_MOXART=y
+CONFIG_DMADEVICES=y
+CONFIG_MOXART_DMA=y
+# CONFIG_IOMMU_SUPPORT is not set
+CONFIG_EXT3_FS=y
+CONFIG_TMPFS=y
+CONFIG_CONFIGFS_FS=y
+CONFIG_JFFS2_FS=y
+CONFIG_PRINTK_TIME=y
+CONFIG_DEBUG_INFO=y
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
+CONFIG_DEBUG_PAGEALLOC=y
+CONFIG_DEBUG_OBJECTS=y
+CONFIG_DEBUG_KMEMLEAK=y
+CONFIG_DEBUG_STACK_USAGE=y
+CONFIG_DEBUG_MEMORY_INIT=y
+CONFIG_DEBUG_SHIRQ=y
+CONFIG_DETECT_HUNG_TASK=y
+# CONFIG_SCHED_DEBUG is not set
+# CONFIG_DEBUG_PREEMPT is not set
+CONFIG_PROVE_LOCKING=y
+CONFIG_DMA_API_DEBUG=y
+CONFIG_KGDB=y
+CONFIG_DEBUG_LL=y
+CONFIG_DEBUG_LL_UART_8250=y
+CONFIG_DEBUG_UART_PHYS=0x98200000
+CONFIG_DEBUG_UART_VIRT=0xf9820000
+CONFIG_EARLY_PRINTK=y
+CONFIG_KEYS=y
+CONFIG_CRC32_BIT=y
diff --git a/arch/arm/mach-moxart/Kconfig b/arch/arm/mach-moxart/Kconfig
new file mode 100644
index 0000000..ba470d6
--- /dev/null
+++ b/arch/arm/mach-moxart/Kconfig
@@ -0,0 +1,31 @@
+config ARCH_MOXART
+	bool "MOXA ART SoC" if ARCH_MULTI_V4T
+	select CPU_FA526
+	select ARM_DMA_MEM_BUFFERABLE
+	select DMA_OF
+	select USE_OF
+	select CLKSRC_OF
+	select CLKSRC_MMIO
+	select HAVE_CLK
+	select COMMON_CLK
+	select GENERIC_IRQ_CHIP
+	select ARCH_REQUIRE_GPIOLIB
+	select GENERIC_CLOCKEVENTS
+	select PHYLIB if NETDEVICES
+	help
+	  Say Y here if you want to run your kernel on hardware with a
+	  MOXA ART SoC.
+	  The MOXA ART SoC is based on a Faraday FA526 ARMv4 32-bit
+	  192 MHz CPU with MMU and 16KB/8KB D/I-cache (UC-7112-LX).
+	  Used on models UC-7101, UC-7112/UC-7110, IA240/IA241, IA3341.
+
+if ARCH_MOXART
+
+config MACH_UC7112LX
+	bool "MOXA UC-7112-LX"
+	depends on ARCH_MOXART
+	help
+	  Say Y here if you intend to run this kernel on a MOXA
+	  UC-7112-LX embedded computer.
+
+endif
diff --git a/arch/arm/mach-moxart/Makefile b/arch/arm/mach-moxart/Makefile
new file mode 100644
index 0000000..fa022eb
--- /dev/null
+++ b/arch/arm/mach-moxart/Makefile
@@ -0,0 +1,3 @@
+# Object file lists.
+
+obj-$(CONFIG_MACH_UC7112LX)	+= moxart.o
diff --git a/arch/arm/mach-moxart/moxart.c b/arch/arm/mach-moxart/moxart.c
new file mode 100644
index 0000000..86b6d9b
--- /dev/null
+++ b/arch/arm/mach-moxart/moxart.c
@@ -0,0 +1,15 @@
+/*
+ * arch/arm/mach-moxart/moxart.c
+ *
+ * (C) Copyright 2013, Jonas Jensen <jonas.jensen@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
-- 
1.8.2.1

