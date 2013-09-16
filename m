Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3IPXKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:10:45 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:41448 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3IPXJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:58 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH 28/28] mips: use common of_flat_dt_get_machine_name
Date: Mon, 16 Sep 2013 18:09:24 -0500
Message-Id: <1379372965-22359-29-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert mips to use the common of_flat_dt_get_machine_name function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/kernel/prom.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index 0b2485f..3c3b0df 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -47,24 +47,11 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 	return __alloc_bootmem(size, align, __pa(MAX_DMA_ADDRESS));
 }
 
-int __init early_init_dt_scan_model(unsigned long node,	const char *uname,
-				    int depth, void *data)
-{
-	if (!depth) {
-		char *model = of_get_flat_dt_prop(node, "model", NULL);
-
-		if (model)
-			mips_set_machine_name(model);
-	}
-	return 0;
-}
-
 void __init __dt_setup_arch(struct boot_param_header *bph)
 {
 	if (!early_init_dt_scan(bph))
 		return;
 
-	/* try to load the mips machine name */
-	of_scan_flat_dt(early_init_dt_scan_model, NULL);
+	mips_set_machine_name(of_flat_dt_get_machine_name());
 }
 #endif
-- 
1.8.1.2

