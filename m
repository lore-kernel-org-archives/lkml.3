Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3GDOpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:45:13 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:36070 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3GDOpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:45:11 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org, arnd@arndb.de,
        olof@lixom.net, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v3 1/4] ARM: mach-moxart: add MOXA ART SoC files
Date: Thu,  4 Jul 2013 16:44:38 +0200
Message-Id: <1372949078-8154-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371040448-28742-2-git-send-email-jonas.jensen@gmail.com>
References: <1371040448-28742-2-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MOXA ART SoC support.

The MOXA ART SoC is based on a Faraday FA526 ARMv4 32-bit 192 MHz CPU
with MMU and 16KB/8KB D/I-cache (UC-7112-LX).

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20130703
    
    Changes since v2:
    
    1. add CLKSRC_MMIO and GENERIC_CLOCKEVENTS to ARCH_MOXART
    2. call of_clk_init(NULL) from .init_time hook

 arch/arm/Kconfig                  |   2 +
 arch/arm/Makefile                 |   1 +
 arch/arm/configs/moxart_defconfig | 116 ++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-moxart/Kconfig      |  29 ++++++++++
 arch/arm/mach-moxart/Makefile     |   3 +
 arch/arm/mach-moxart/moxart.c     |  43 ++++++++++++++
 6 files changed, 194 insertions(+)
 create mode 100644 arch/arm/configs/moxart_defconfig
 create mode 100644 arch/arm/mach-moxart/Kconfig
 create mode 100644 arch/arm/mach-moxart/Makefile
 create mode 100644 arch/arm/mach-moxart/moxart.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 0ac9be6..d84161c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -964,6 +964,8 @@ source "arch/arm/mach-ks8695/Kconfig"
 
 source "arch/arm/mach-msm/Kconfig"
 
+source "arch/arm/mach-moxart/Kconfig"
+
 source "arch/arm/mach-mv78xx0/Kconfig"
 
 source "arch/arm/mach-imx/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 72caf82..17907c8 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -158,6 +158,7 @@ machine-$(CONFIG_ARCH_KIRKWOOD)		+= kirkwood
 machine-$(CONFIG_ARCH_KS8695)		+= ks8695
 machine-$(CONFIG_ARCH_LPC32XX)		+= lpc32xx
 machine-$(CONFIG_ARCH_MMP)		+= mmp
+machine-$(CONFIG_ARCH_MOXART)		+= moxart
 machine-$(CONFIG_ARCH_MSM)		+= msm
 machine-$(CONFIG_ARCH_MV78XX0)		+= mv78xx0
 machine-$(CONFIG_ARCH_MXC)		+= imx
diff --git a/arch/arm/configs/moxart_defconfig b/arch/arm/configs/moxart_defconfig
new file mode 100644
index 0000000..9977d33
--- /dev/null
+++ b/arch/arm/configs/moxart_defconfig
@@ -0,0 +1,116 @@
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
+CONFIG_ARCH_MULTI_V4=y
+# CONFIG_ARCH_MULTI_V7 is not set
+CONFIG_ARCH_MOXART=y
+CONFIG_MACH_UC7112LX=y
+CONFIG_PREEMPT=y
+CONFIG_AEABI=y
+# CONFIG_OABI_COMPAT is not set
+# CONFIG_ATAGS is not set
+CONFIG_ARM_APPENDED_DTB=y
+# CONFIG_SUSPEND is not set
+CONFIG_NET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
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
+# CONFIG_NET_VENDOR_ARC is not set
+# CONFIG_NET_CADENCE is not set
+# CONFIG_NET_VENDOR_BROADCOM is not set
+# CONFIG_NET_VENDOR_CIRRUS is not set
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
+CONFIG_ARM_MOXART_ETHER=y
+# CONFIG_WLAN is not set
+# CONFIG_INPUT is not set
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
+CONFIG_GPIO_MOXART=y
+# CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+CONFIG_MOXART_WDT=y
+# CONFIG_USB_SUPPORT is not set
+CONFIG_MMC=y
+CONFIG_MMC_SDHCI_MOXART=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_DRV_MOXART=y
+CONFIG_DMADEVICES=y
+# CONFIG_IOMMU_SUPPORT is not set
+CONFIG_EXT3_FS=y
+CONFIG_TMPFS=y
+CONFIG_JFFS2_FS=y
+CONFIG_PRINTK_TIME=y
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_SHIRQ=y
+CONFIG_DETECT_HUNG_TASK=y
+# CONFIG_SCHED_DEBUG is not set
+# CONFIG_DEBUG_PREEMPT is not set
+CONFIG_PROVE_LOCKING=y
+CONFIG_DEBUG_INFO=y
+CONFIG_DEBUG_MEMORY_INIT=y
+# CONFIG_FTRACE is not set
+CONFIG_DEBUG_LL=y
+CONFIG_EARLY_PRINTK=y
+CONFIG_KEYS=y
diff --git a/arch/arm/mach-moxart/Kconfig b/arch/arm/mach-moxart/Kconfig
new file mode 100644
index 0000000..a6ad825
--- /dev/null
+++ b/arch/arm/mach-moxart/Kconfig
@@ -0,0 +1,29 @@
+config ARCH_MOXART
+	bool "MOXA ART SoC" if ARCH_MULTI_V4
+	select CPU_FA526
+	select ARM_DMA_MEM_BUFFERABLE
+	select USE_OF
+	select CLKSRC_OF
+	select CLKSRC_MMIO
+	select HAVE_CLK
+	select COMMON_CLK
+	select GENERIC_IRQ_CHIP
+	select ARCH_REQUIRE_GPIOLIB
+	select GENERIC_CLOCKEVENTS
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
index 0000000..86b4e49
--- /dev/null
+++ b/arch/arm/mach-moxart/moxart.c
@@ -0,0 +1,43 @@
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+#include <linux/init.h>
+#include <linux/clocksource.h>
+#include <linux/of_platform.h>
+#include <linux/clk-provider.h>
+
+#include <asm/mach/arch.h>
+
+static const char * const moxart_dt_compat[] = {
+	"moxa,moxart",
+	NULL,
+};
+
+static void __init moxart_init_time(void)
+{
+	of_clk_init(NULL);
+	clocksource_of_init();
+}
+
+DT_MACHINE_START(MOXART, "MOXA UC-7112-LX")
+	.init_time		= moxart_init_time,
+	.dt_compat		= moxart_dt_compat,
+MACHINE_END
-- 
1.8.2.1

