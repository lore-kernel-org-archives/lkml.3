Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbaDWB1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:27:54 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:44147 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaDWBSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:18:54 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH v2 04/21] mips: ralink: convert to use unflatten_and_copy_device_tree
Date: Tue, 22 Apr 2014 20:18:04 -0500
Message-Id: <1398215901-25609-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

The ralink FDT code can be simplified by using
unflatten_and_copy_device_tree function. This removes all accesses to
FDT header data by the arch code.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
v2: no change

 arch/mips/ralink/of.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/arch/mips/ralink/of.c b/arch/mips/ralink/of.c
index eccc552..0170d82 100644
--- a/arch/mips/ralink/of.c
+++ b/arch/mips/ralink/of.c
@@ -52,30 +52,7 @@ __iomem void *plat_of_remap_node(const char *node)
 
 void __init device_tree_init(void)
 {
-	unsigned long base, size;
-	void *fdt_copy;
-
-	if (!initial_boot_params)
-		return;
-
-	base = virt_to_phys((void *)initial_boot_params);
-	size = be32_to_cpu(initial_boot_params->totalsize);
-
-	/* Before we do anything, lets reserve the dt blob */
-	reserve_bootmem(base, size, BOOTMEM_DEFAULT);
-
-	/* The strings in the flattened tree are referenced directly by the
-	 * device tree, so copy the flattened device tree from init memory
-	 * to regular memory.
-	 */
-	fdt_copy = alloc_bootmem(size);
-	memcpy(fdt_copy, initial_boot_params, size);
-	initial_boot_params = fdt_copy;
-
-	unflatten_device_tree();
-
-	/* free the space reserved for the dt blob */
-	free_bootmem(base, size);
+	unflatten_and_copy_device_tree();
 }
 
 void __init plat_mem_setup(void)
-- 
1.9.1

