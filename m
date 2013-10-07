Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab3JGQaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:30:24 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:50233 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab3JGQaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:30:16 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 14/29] metag: use early_init_dt_scan
Date: Mon,  7 Oct 2013 11:29:22 -0500
Message-Id: <1381163377-21044-15-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
References: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert metag to use new early_init_dt_scan function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/devtree.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/metag/kernel/devtree.c b/arch/metag/kernel/devtree.c
index 049af56..68c2fee 100644
--- a/arch/metag/kernel/devtree.c
+++ b/arch/metag/kernel/devtree.c
@@ -43,18 +43,16 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
  */
 struct machine_desc * __init setup_machine_fdt(void *dt)
 {
-	struct boot_param_header *devtree = dt;
 	struct machine_desc *mdesc, *mdesc_best = NULL;
 	unsigned int score, mdesc_score = ~1;
 	unsigned long dt_root;
 	const char *model;
 
 	/* check device tree validity */
-	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER)
+	if (!early_init_dt_scan(dt))
 		return NULL;
 
 	/* Search the mdescs for the 'best' compatible value match */
-	initial_boot_params = devtree;
 	dt_root = of_get_flat_dt_root();
 
 	for_each_machine_desc(mdesc) {
@@ -90,9 +88,6 @@ struct machine_desc * __init setup_machine_fdt(void *dt)
 		model = "<unknown>";
 	pr_info("Machine: %s, model: %s\n", mdesc_best->name, model);
 
-	/* Retrieve various information from the /chosen node */
-	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
-
 	return mdesc_best;
 
 }
-- 
1.8.1.2

