Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3JQLTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 07:19:30 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57517 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab3JQLTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:19:18 -0400
From: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, catalin.marinas@arm.com,
        will.deacon@arm.com, steve.capper@linaro.org, nico@linaro.org,
        srikar@linux.vnet.ibm.com, rostedt@goodmis.org,
        masami.hiramatsu.pt@hitachi.com, dsaxena@linaro.org,
        jiang.liu@huawei.com, Vijaya.Kumar@caviumnetworks.com,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
Subject: [PATCH RFC 5/6] arm64: Enable kprobes support for arm64 platform
Date: Thu, 17 Oct 2013 16:47:50 +0530
Message-Id: <1382008671-4515-6-git-send-email-sandeepa.prabhu@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
References: <1382008671-4515-1-git-send-email-sandeepa.prabhu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables kprobes support in arm64 common defconfig
file.

Signed-off-by: Sandeepa Prabhu <sandeepa.prabhu@linaro.org>
---
 arch/arm64/configs/defconfig | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 31c81e9..105f37c 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1,12 +1,11 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_POSIX_MQUEUE=y
-CONFIG_BSD_PROCESS_ACCT=y
-CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
+CONFIG_BSD_PROCESS_ACCT=y
+CONFIG_BSD_PROCESS_ACCT_V3=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_LOG_BUF_SHIFT=14
@@ -19,6 +18,7 @@ CONFIG_BLK_DEV_INITRD=y
 CONFIG_KALLSYMS_ALL=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_PROFILING=y
+CONFIG_KPROBES=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
@@ -42,13 +42,12 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_WIRELESS is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_DEVTMPFS=y
-CONFIG_BLK_DEV=y
+CONFIG_VIRTIO_BLK=y
 CONFIG_SCSI=y
 # CONFIG_SCSI_PROC_FS is not set
 CONFIG_BLK_DEV_SD=y
 # CONFIG_SCSI_LOWLEVEL is not set
 CONFIG_NETDEVICES=y
-CONFIG_MII=y
 CONFIG_SMC91X=y
 # CONFIG_WLAN is not set
 CONFIG_INPUT_EVDEV=y
@@ -57,9 +56,9 @@ CONFIG_INPUT_EVDEV=y
 CONFIG_LEGACY_PTY_COUNT=16
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
-CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
 CONFIG_FB=y
@@ -69,12 +68,13 @@ CONFIG_LOGO=y
 # CONFIG_LOGO_LINUX_MONO is not set
 # CONFIG_LOGO_LINUX_VGA16 is not set
 # CONFIG_USB_SUPPORT is not set
+CONFIG_VIRTIO_MMIO=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
-CONFIG_EXT4_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 # CONFIG_EXT3_FS_XATTR is not set
+CONFIG_EXT4_FS=y
 CONFIG_FUSE_FS=y
 CONFIG_CUSE=y
 CONFIG_VFAT_FS=y
@@ -84,12 +84,10 @@ CONFIG_NFS_FS=y
 CONFIG_ROOT_NFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ISO8859_1=y
-CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_FS=y
+CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_KERNEL=y
 # CONFIG_SCHED_DEBUG is not set
-CONFIG_DEBUG_INFO=y
 # CONFIG_FTRACE is not set
 CONFIG_ATOMIC64_SELFTEST=y
-CONFIG_VIRTIO_MMIO=y
-CONFIG_VIRTIO_BLK=y
-- 
1.8.1.2

