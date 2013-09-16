Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3IPXJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:09:47 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:49618 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3IPXJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:40 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 08/28] metag: use unflatten_and_copy_device_tree
Date: Mon, 16 Sep 2013 18:09:04 -0500
Message-Id: <1379372965-22359-9-git-send-email-robherring2@gmail.com>
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
Cc: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/devtree.c | 16 ----------------
 arch/metag/kernel/setup.c   |  4 +---
 2 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/arch/metag/kernel/devtree.c b/arch/metag/kernel/devtree.c
index 7cd0252..049af56 100644
--- a/arch/metag/kernel/devtree.c
+++ b/arch/metag/kernel/devtree.c
@@ -94,21 +94,5 @@ struct machine_desc * __init setup_machine_fdt(void *dt)
 	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
 
 	return mdesc_best;
-}
 
-/**
- * copy_fdt - Copy device tree into non-init memory.
- *
- * We must copy the flattened device tree blob into non-init memory because the
- * unflattened device tree will reference the strings in it directly.
- */
-void __init copy_fdt(void)
-{
-	void *alloc = early_init_dt_alloc_memory_arch(
-			be32_to_cpu(initial_boot_params->totalsize), 0x40);
-	if (alloc) {
-		memcpy(alloc, initial_boot_params,
-		       be32_to_cpu(initial_boot_params->totalsize));
-		initial_boot_params = alloc;
-	}
 }
diff --git a/arch/metag/kernel/setup.c b/arch/metag/kernel/setup.c
index c396cd0..2c697d3 100644
--- a/arch/metag/kernel/setup.c
+++ b/arch/metag/kernel/setup.c
@@ -408,9 +408,7 @@ void __init setup_arch(char **cmdline_p)
 	cpu_2_hwthread_id[smp_processor_id()] = hard_processor_id();
 	hwthread_id_2_cpu[hard_processor_id()] = smp_processor_id();
 
-	/* Copy device tree blob into non-init memory before unflattening */
-	copy_fdt();
-	unflatten_device_tree();
+	unflatten_and_copy_device_tree();
 
 #ifdef CONFIG_SMP
 	smp_init_cpus();
-- 
1.8.1.2

