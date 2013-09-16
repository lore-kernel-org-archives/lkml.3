Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3IPXNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:13:48 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43416 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab3IPXJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:44 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org
Subject: [PATCH 13/28] c6x: use early_init_dt_scan
Date: Mon, 16 Sep 2013 18:09:09 -0500
Message-Id: <1379372965-22359-14-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert c6x to use new early_init_dt_scan function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: linux-c6x-dev@linux-c6x.org
---
 arch/c6x/kernel/devicetree.c | 19 -------------------
 arch/c6x/kernel/setup.c      |  2 +-
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/c6x/kernel/devicetree.c b/arch/c6x/kernel/devicetree.c
index 5e8c838..d28a92f 100644
--- a/arch/c6x/kernel/devicetree.c
+++ b/arch/c6x/kernel/devicetree.c
@@ -10,28 +10,9 @@
  *
  */
 #include <linux/init.h>
-#include <linux/of.h>
-#include <linux/of_fdt.h>
 #include <linux/initrd.h>
 #include <linux/memblock.h>
 
-void __init early_init_devtree(void *params)
-{
-	/* Setup flat device-tree pointer */
-	initial_boot_params = params;
-
-	/* Retrieve various informations from the /chosen node of the
-	 * device-tree, including the platform type, initrd location and
-	 * size and more ...
-	 */
-	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
-
-	/* Scan memory nodes and rebuild MEMBLOCKs */
-	of_scan_flat_dt(early_init_dt_scan_root, NULL);
-	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
-}
-
-
 #ifdef CONFIG_BLK_DEV_INITRD
 void __init early_init_dt_setup_initrd_arch(u64 start, u64 end)
 {
diff --git a/arch/c6x/kernel/setup.c b/arch/c6x/kernel/setup.c
index 0e5a812..731db4b 100644
--- a/arch/c6x/kernel/setup.c
+++ b/arch/c6x/kernel/setup.c
@@ -287,7 +287,7 @@ notrace void __init machine_init(unsigned long dt_ptr)
 		fdt = dtb;
 
 	/* Do some early initialization based on the flat device tree */
-	early_init_devtree(fdt);
+	early_init_dt_scan(fdt);
 
 	parse_early_param();
 }
-- 
1.8.1.2

