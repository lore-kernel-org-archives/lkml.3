Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110Ab3JPLDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:03:40 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:40343 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955Ab3JPLDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:03:35 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/8] zorro: Refactor conditional handling of Zorro device name database
Date: Wed, 16 Oct 2013 13:03:21 +0200
Message-Id: <1381921405-11206-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
References: <1381921405-11206-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using an empty static inline function in the CONFIG_ZORRO_NAMES=n case
allows to drop compilation of names.c.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/Makefile |    3 ++-
 drivers/zorro/names.c  |   10 ----------
 drivers/zorro/zorro.h  |    5 +++++
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/zorro/Makefile b/drivers/zorro/Makefile
index f62172603215..7dc5332ff984 100644
--- a/drivers/zorro/Makefile
+++ b/drivers/zorro/Makefile
@@ -2,8 +2,9 @@
 # Makefile for the Zorro bus specific drivers.
 #
 
-obj-$(CONFIG_ZORRO)	+= zorro.o zorro-driver.o zorro-sysfs.o names.o
+obj-$(CONFIG_ZORRO)	+= zorro.o zorro-driver.o zorro-sysfs.o
 obj-$(CONFIG_PROC_FS)	+= proc.o
+obj-$(CONFIG_ZORRO_NAMES) +=  names.o
 
 hostprogs-y 		:= gen-devlist
 
diff --git a/drivers/zorro/names.c b/drivers/zorro/names.c
index e44e04c4f29d..6f3fd9903ac3 100644
--- a/drivers/zorro/names.c
+++ b/drivers/zorro/names.c
@@ -15,8 +15,6 @@
 #include <linux/zorro.h>
 
 
-#ifdef CONFIG_ZORRO_NAMES
-
 struct zorro_prod_info {
 	__u16 prod;
 	unsigned short seen;
@@ -97,11 +95,3 @@ void __init zorro_name_device(struct zorro_dev *dev)
 		}
 	}
 }
-
-#else
-
-void __init zorro_name_device(struct zorro_dev *dev)
-{
-}
-
-#endif
diff --git a/drivers/zorro/zorro.h b/drivers/zorro/zorro.h
index b682d5ccd63f..34119fb4e560 100644
--- a/drivers/zorro/zorro.h
+++ b/drivers/zorro/zorro.h
@@ -1,4 +1,9 @@
 
+#ifdef CONFIG_ZORRO_NAMES
 extern void zorro_name_device(struct zorro_dev *z);
+#else
+static inline void zorro_name_device(struct zorro_dev *dev) { }
+#endif
+
 extern int zorro_create_sysfs_dev_files(struct zorro_dev *z);
 
-- 
1.7.9.5

