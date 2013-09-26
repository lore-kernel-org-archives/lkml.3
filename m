Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab3IZSxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:53:06 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54799 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab3IZSvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:39 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 18/21] powerpc: clean-up include ordering in prom.h
Date: Thu, 26 Sep 2013 13:50:53 -0500
Message-Id: <1380221456-11192-19-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Now that the core OF headers don't depend on prom.h, rearrange the
includes. There are still lots of implicit includes in the powerpc tree,
so the includes of OF headers are still necessary.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/powerpc/include/asm/prom.h | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index b8774bd..7687f82 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -1,4 +1,3 @@
-#include <linux/of.h>	/* linux/of.h gets to determine #include ordering */
 #ifndef _POWERPC_PROM_H
 #define _POWERPC_PROM_H
 #ifdef __KERNEL__
@@ -20,6 +19,13 @@
 #include <asm/irq.h>
 #include <linux/atomic.h>
 
+/* These includes should be removed once implicit includes are cleaned up. */
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+
 /*
  * OF address retreival & translation
  */
@@ -125,14 +131,5 @@ struct of_drconf_cell {
  */
 extern unsigned char ibm_architecture_vec[];
 
-/* These includes are put at the bottom because they may contain things
- * that are overridden by this file.  Ideally they shouldn't be included
- * by this file, but there are a bunch of .c files that currently depend
- * on it.  Eventually they will be cleaned up. */
-#include <linux/of_fdt.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-#include <linux/platform_device.h>
-
 #endif /* __KERNEL__ */
 #endif /* _POWERPC_PROM_H */
-- 
1.8.1.2

