Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbaDWBUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:20:35 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:58964 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbaDWBTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:19:12 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
Subject: [PATCH v2 20/21] of/fdt: convert initial_boot_params to opaque pointer
Date: Tue, 22 Apr 2014 20:18:20 -0500
Message-Id: <1398215901-25609-21-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Now that all accesses to FDT header data has been converted to accessor
helpers, initial_boot_params can become an opaque pointer.

Signed-off-by: Rob Herring <robh@kernel.org>
---
v2: no change

 drivers/of/fdt.c       | 2 +-
 include/linux/of_fdt.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 358bcf0..a6f83ea 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -372,7 +372,7 @@ EXPORT_SYMBOL_GPL(of_fdt_unflatten_tree);
 int __initdata dt_root_addr_cells;
 int __initdata dt_root_size_cells;
 
-struct boot_param_header *initial_boot_params;
+void *initial_boot_params;
 
 #ifdef CONFIG_OF_EARLY_FLATTREE
 
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index e10099c..1f882e1 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -78,7 +78,7 @@ extern void of_fdt_unflatten_tree(unsigned long *blob,
 /* TBD: Temporary export of fdt globals - remove when code fully merged */
 extern int __initdata dt_root_addr_cells;
 extern int __initdata dt_root_size_cells;
-extern struct boot_param_header *initial_boot_params;
+extern void *initial_boot_params;
 
 extern char __dtb_start[];
 extern char __dtb_end[];
-- 
1.9.1

