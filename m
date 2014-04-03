Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaDCWSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:18:05 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:47400 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaDCWRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:39 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH 10/20] of/fdt: remove some unneeded includes
Date: Thu,  3 Apr 2014 17:16:53 -0500
Message-Id: <1396563423-30893-11-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Whatever needed powerpc machdep.h appears to have been removed, so the
include can be dropped.

module.h is not needed as this code is always built-in.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/fdt.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 2085d47..0139b65 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/initrd.h>
 #include <linux/memblock.h>
-#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/of_reserved_mem.h>
@@ -23,10 +22,6 @@
 #include <linux/debugfs.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
-#ifdef CONFIG_PPC
-#include <asm/machdep.h>
-#endif /* CONFIG_PPC */
-
 #include <asm/page.h>
 
 char *of_fdt_get_string(struct boot_param_header *blob, u32 offset)
-- 
1.8.3.2

