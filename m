Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaDCWRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:17:47 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:47673 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaDCWRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:32 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [PATCH 04/20] mips: ralink: convert to use unflatten_and_copy_device_tree
Date: Thu,  3 Apr 2014 17:16:47 -0500
Message-Id: <1396563423-30893-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
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
1.8.3.2

