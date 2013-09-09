Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3IIBDI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 21:03:08 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:46658 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3IIBDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 21:03:06 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <tao.peng@emc.com>, Guenter Roeck <linux@roeck-us.net>,
        Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] staging: Disable lustre file system for MIPS, SH, and XTENSA
Date: Sun,  8 Sep 2013 18:03:00 -0700
Message-Id: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mips allmodconfig fails with

ERROR: "copy_from_user_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko]
undefined!

which is due to LUSTRE using copy_from_user_page which is not exported by any
architecture. Unfortunately, LUSTRE can only be built as module, so there is no
easy fix.

MIPS, SH, and optionally XTENSA implement copy_from_user_page as unexported
functions. Disable LUSTRE for those.

Cc: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/staging/lustre/lustre/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 4e898e4..07ce43d 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -1,6 +1,6 @@
 config LUSTRE_FS
 	tristate "Lustre file system client support"
-	depends on INET && m
+	depends on INET && m && !MIPS && !XTENSA && !SUPERH
 	select LNET
 	select CRYPTO
 	select CRYPTO_CRC32
-- 
1.7.9.7

