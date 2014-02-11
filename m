Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaBKTq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:46:59 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39370 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754041AbaBKToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:44:24 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/3] arm: at91sam9rl: refresh defconfig
Date: Tue, 11 Feb 2014 20:43:59 +0100
Message-Id: <1392147841-7815-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392147841-7815-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1392147841-7815-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The defconfig for the at91sam9rl is quite old, refresh it:
 - now uses EABI instead of OABI
 - add devtmpfs support
 - add UBI/UBIfs support
 - remove a few config symbols that disappeared

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/configs/at91sam9rl_defconfig | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/configs/at91sam9rl_defconfig b/arch/arm/configs/at91sam9rl_defconfig
index 7cf87856d63c..e60f51afcf6a 100644
--- a/arch/arm/configs/at91sam9rl_defconfig
+++ b/arch/arm/configs/at91sam9rl_defconfig
@@ -1,8 +1,8 @@
-CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 # CONFIG_SWAP is not set
 CONFIG_SYSVIPC=y
 CONFIG_LOG_BUF_SHIFT=14
+CONFIG_EMBEDDED=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_SLAB=y
 CONFIG_MODULES=y
@@ -15,20 +15,23 @@ CONFIG_ARCH_AT91SAM9RL=y
 CONFIG_MACH_AT91SAM9RLEK=y
 CONFIG_AT91_PROGRAMMABLE_CLOCKS=y
 # CONFIG_ARM_THUMB is not set
+CONFIG_AEABI=y
 CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
 CONFIG_CMDLINE="mem=64M console=ttyS0,115200 initrd=0x21100000,17105363 root=/dev/ram0 rw"
-CONFIG_FPE_NWFPE=y
+CONFIG_AUTO_ZRELADDR=y
 CONFIG_NET=y
 CONFIG_UNIX=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_MTD=y
 CONFIG_MTD_CMDLINE_PARTS=y
-CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_DATAFLASH=y
 CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
+CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=4
@@ -67,6 +70,7 @@ CONFIG_EXT2_FS=y
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
+CONFIG_UBIFS_FS=y
 CONFIG_CRAMFS=y
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_CODEPAGE_850=y
-- 
1.8.3.2

