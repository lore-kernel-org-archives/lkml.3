Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab3GPQ4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:56:13 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:45962 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab3GPQ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:56:11 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>
Subject: [PATCH] um/configs: don't use devtmpfs in defconfig
Date: Tue, 16 Jul 2013 22:22:05 +0530
Message-Id: <1373993525-25629-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.3.754.g9c3c367
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid creating lots of bogus devices nodes like /dev/tty* (since
User-Mode Linux does not have virtual consoles.

Cc: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 Applies on top of the patch I posted earlier.

 arch/um/configs/i386_defconfig   | 3 +--
 arch/um/configs/x86_64_defconfig | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/um/configs/i386_defconfig b/arch/um/configs/i386_defconfig
index 995aecd..93f4f97 100644
--- a/arch/um/configs/i386_defconfig
+++ b/arch/um/configs/i386_defconfig
@@ -293,8 +293,7 @@ CONFIG_HOSTAUDIO=m
 # Generic Driver Options
 #
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
-CONFIG_DEVTMPFS=y
-CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_DEVTMPFS is not set
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 CONFIG_FW_LOADER=y
diff --git a/arch/um/configs/x86_64_defconfig b/arch/um/configs/x86_64_defconfig
index f2c6123..17650a6 100644
--- a/arch/um/configs/x86_64_defconfig
+++ b/arch/um/configs/x86_64_defconfig
@@ -285,8 +285,7 @@ CONFIG_HOSTAUDIO=m
 # Generic Driver Options
 #
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
-CONFIG_DEVTMPFS=y
-CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_DEVTMPFS is not set
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 CONFIG_FW_LOADER=y
-- 
1.8.3.3.754.g9c3c367

