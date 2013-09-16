Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3IPXOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:14:30 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:46768 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3IPXJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:41 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 10/28] arc: use early_init_dt_scan
Date: Mon, 16 Sep 2013 18:09:06 -0500
Message-Id: <1379372965-22359-11-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert arc to use new early_init_dt_scan function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/devtree.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
index eeb613a..1ab6f35 100644
--- a/arch/arc/kernel/devtree.c
+++ b/arch/arc/kernel/devtree.c
@@ -27,7 +27,6 @@
  */
 struct machine_desc * __init setup_machine_fdt(void *dt)
 {
-	struct boot_param_header *devtree = dt;
 	struct machine_desc *mdesc = NULL, *mdesc_best = NULL;
 	unsigned int score, mdesc_score = ~1;
 	unsigned long dt_root;
@@ -36,11 +35,9 @@ struct machine_desc * __init setup_machine_fdt(void *dt)
 	char manufacturer[16];
 	unsigned long len;
 
-	/* check device tree validity */
-	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER)
+	if (!early_init_dt_scan(dt))
 		return NULL;
 
-	initial_boot_params = devtree;
 	dt_root = of_get_flat_dt_root();
 
 	/*
@@ -85,15 +82,6 @@ struct machine_desc * __init setup_machine_fdt(void *dt)
 
 	pr_info("Board \"%s\" from %s (Manufacturer)\n", model, manufacturer);
 
-	/* Retrieve various information from the /chosen node */
-	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
-
-	/* Initialize {size,address}-cells info */
-	of_scan_flat_dt(early_init_dt_scan_root, NULL);
-
-	/* Setup memory, calling early_init_dt_add_memory_arch */
-	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
-
 	clk = of_get_flat_dt_prop(dt_root, "clock-frequency", &len);
 	if (clk)
 		arc_set_core_freq(of_read_ulong(clk, len/4));
-- 
1.8.1.2

