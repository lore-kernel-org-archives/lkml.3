Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaDCWSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:18:40 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35340 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaDCWRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:53 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH 19/20] of/fdt: convert initial_boot_params to opaque pointer
Date: Thu,  3 Apr 2014 17:17:02 -0500
Message-Id: <1396563423-30893-20-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Now that all accesses to FDT header data has been converted to accessor
helpers, initial_boot_params can become an opaque pointer.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/of/fdt.c       | 2 +-
 include/linux/of_fdt.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index e940566..381b858 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -366,7 +366,7 @@ EXPORT_SYMBOL_GPL(of_fdt_unflatten_tree);
 int __initdata dt_root_addr_cells;
 int __initdata dt_root_size_cells;
 
-struct boot_param_header *initial_boot_params;
+void *initial_boot_params;
 
 #ifdef CONFIG_OF_EARLY_FLATTREE
 
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index d7b7fdd..aa7fb87 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -80,7 +80,7 @@ extern void of_fdt_unflatten_tree(unsigned long *blob,
 /* TBD: Temporary export of fdt globals - remove when code fully merged */
 extern int __initdata dt_root_addr_cells;
 extern int __initdata dt_root_size_cells;
-extern struct boot_param_header *initial_boot_params;
+extern void *initial_boot_params;
 
 extern char __dtb_start[];
 extern char __dtb_end[];
-- 
1.8.3.2

