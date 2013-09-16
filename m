Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab3IPXPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:15:20 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:39268 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3IPXJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:39 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>, linux-xtensa@linux-xtensa.org
Subject: [PATCH 07/28] xtensa: use unflatten_and_copy_device_tree
Date: Mon, 16 Sep 2013 18:09:03 -0500
Message-Id: <1379372965-22359-8-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Use the common unflatten_and_copy_device_tree to copy the built-in FDT
out of init section.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
---
 arch/xtensa/kernel/setup.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 946fb8d..fc31ec1 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -21,11 +21,8 @@
 #include <linux/screen_info.h>
 #include <linux/bootmem.h>
 #include <linux/kernel.h>
-
-#ifdef CONFIG_OF
 #include <linux/of_fdt.h>
 #include <linux/of_platform.h>
-#endif
 
 #if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)
 # include <linux/console.h>
@@ -252,17 +249,6 @@ void __init early_init_devtree(void *params)
 		of_scan_flat_dt(early_init_dt_scan_memory, NULL);
 }
 
-static void __init copy_devtree(void)
-{
-	void *alloc = early_init_dt_alloc_memory_arch(
-			be32_to_cpu(initial_boot_params->totalsize), 8);
-	if (alloc) {
-		memcpy(alloc, initial_boot_params,
-				be32_to_cpu(initial_boot_params->totalsize));
-		initial_boot_params = alloc;
-	}
-}
-
 static int __init xtensa_device_probe(void)
 {
 	of_platform_populate(NULL, NULL, NULL, NULL);
@@ -525,10 +511,7 @@ void __init setup_arch(char **cmdline_p)
 
 	bootmem_init();
 
-#ifdef CONFIG_OF
-	copy_devtree();
-	unflatten_device_tree();
-#endif
+	unflatten_and_copy_device_tree();
 
 	platform_setup(cmdline_p);
 
-- 
1.8.1.2

