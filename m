Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937728Ab3DKAHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:07:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937299Ab3DKAHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:07:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 16/30] rtc: s3c: make header file local
Date: Thu, 11 Apr 2013 02:04:58 +0200
Message-Id: <1365638712-1028578-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:RwqVoPWugI/2Sblct+qjajHoT4qoxOSdXQ9a0U6zYjz
 otPFjt40LgXJZUnDjtP+wxdobtuy7xn4g/hRPNL3qq/MUyQCDk
 aUormIm9GCCxjVjHhLHYmN5cmmRJO9l/I09u/aS8xLLH3RT352
 G3PqeXPdnOt8m1lwHBOzzjHb7EBRlgranjB4y7Eo0rtJ8dD+U1
 E2e7HLaonpcfQq+YSoXv4L2vos2nGVE8YRIsz+rUuayzNIFMjj
 05sA4yGhqGgizf7mwfMrMrCgOcYA6w0nQ0tyTFRn5GxR/uk+Ha
 JYxITgMD4IYDTbgnOAGR6MMatK8M1xBHxE2Ko5tiaAQA8h0FLW
 z8c8vN1VPerPdL1RMkA5i6T+g0UMN4iAg/i+3N7UtGII6gM0Zo
 JA8FO9r+PZhig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of the rtc driver includes plat/regs-rtc.h,
so we can simply move the file into the same directory,
which allows us to build the file as platform-independent
code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: rtc-linux@googlegroups.com
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
 drivers/rtc/rtc-s3c.c                                                  | 3 +--
 arch/arm/plat-samsung/include/plat/regs-rtc.h => drivers/rtc/rtc-s3c.h | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)
 rename arch/arm/plat-samsung/include/plat/regs-rtc.h => drivers/rtc/rtc-s3c.h (97%)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index fb994e9..7995f79 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -29,9 +29,8 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-#include <mach/hardware.h>
 #include <asm/irq.h>
-#include <plat/regs-rtc.h>
+#include "rtc-s3c.h"
 
 enum s3c_cpu_type {
 	TYPE_S3C2410,
diff --git a/arch/arm/plat-samsung/include/plat/regs-rtc.h b/drivers/rtc/rtc-s3c.h
similarity index 97%
rename from arch/arm/plat-samsung/include/plat/regs-rtc.h
rename to drivers/rtc/rtc-s3c.h
index 0f8263e..004b61a 100644
--- a/arch/arm/plat-samsung/include/plat/regs-rtc.h
+++ b/drivers/rtc/rtc-s3c.h
@@ -1,5 +1,4 @@
-/* arch/arm/mach-s3c2410/include/mach/regs-rtc.h
- *
+/*
  * Copyright (c) 2003 Simtec Electronics <linux@simtec.co.uk>
  *		      http://www.simtec.co.uk/products/SWLINUX/
  *
-- 
1.8.1.2

