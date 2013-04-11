Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937464Ab3DKAG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:06:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58622 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937293Ab3DKAGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-mtd@lists.infradead.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 15/30] mtd: onenand/samsung: make regs-onenand.h file local
Date: Thu, 11 Apr 2013 02:04:57 +0200
Message-Id: <1365638712-1028578-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:PPULMROTb2aTsn4VGZrfAN4IiF0g8Vmk9aYeuMd7ul0
 Fh7+j6rJY8OernzMS5DdjJbitTcb3+AraDUVLNziNJ12Z/wen1
 ypb2wqdrXPvVtciBjyHiEAu9VA8uxy7jOhTHAkjmGiEf5JOwiF
 Ka3U7hGKk7WAT76gvXNp9eWgmDAqCA8dRokgKawQLLvid03CO8
 dqN5qFlepK2ZJfZrSdt41T65W9RqAAlAUhZQ05yLNsVZDErdkh
 IeEMJA3nnr0ubiwha+ePqYjS22sPIFPd+3uN8DxL80gXhP2lGn
 S703IutqMu/x2WIzOtS5ra+8Arkvx6P8iRLx0d+L04G1iWc1Qn
 X3C9O9hov5CxmUpbPWkNFHbou6Lc/jiAnhqROzG+VBBpIRKnEL
 SY5k+wBC9uStQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing uses the NAND register definitions other than the
actual driver, so we can move the header file into the
same local directory, which lets us build it in a multiplatform
configuration.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-mtd@lists.infradead.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/onenand/samsung.c                                         | 4 ++--
 .../include/plat/regs-onenand.h => drivers/mtd/onenand/samsung.h      | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)
 rename arch/arm/plat-samsung/include/plat/regs-onenand.h => drivers/mtd/onenand/samsung.h (98%)

diff --git a/drivers/mtd/onenand/samsung.c b/drivers/mtd/onenand/samsung.c
index 33f2a8f..2cf7408 100644
--- a/drivers/mtd/onenand/samsung.c
+++ b/drivers/mtd/onenand/samsung.c
@@ -23,11 +23,11 @@
 #include <linux/mtd/partitions.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 
 #include <asm/mach/flash.h>
-#include <plat/regs-onenand.h>
 
-#include <linux/io.h>
+#include "samsung.h"
 
 enum soc_type {
 	TYPE_S3C6400,
diff --git a/arch/arm/plat-samsung/include/plat/regs-onenand.h b/drivers/mtd/onenand/samsung.h
similarity index 98%
rename from arch/arm/plat-samsung/include/plat/regs-onenand.h
rename to drivers/mtd/onenand/samsung.h
index 930ea8b..c4a80e6 100644
--- a/arch/arm/plat-samsung/include/plat/regs-onenand.h
+++ b/drivers/mtd/onenand/samsung.h
@@ -11,8 +11,6 @@
 #ifndef __SAMSUNG_ONENAND_H__
 #define __SAMSUNG_ONENAND_H__
 
-#include <mach/hardware.h>
-
 /*
  * OneNAND Controller
  */
-- 
1.8.1.2

