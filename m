Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaDWBTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:19:09 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:46521 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbaDWBS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:18:59 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
Subject: [PATCH v2 09/21] of/fdt: remove some unneeded includes
Date: Tue, 22 Apr 2014 20:18:09 -0500
Message-Id: <1398215901-25609-10-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
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
v2: no change

 drivers/of/fdt.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 7a2ef7b..63bdcee 100644
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
@@ -22,10 +21,6 @@
 #include <linux/slab.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
-#ifdef CONFIG_PPC
-#include <asm/machdep.h>
-#endif /* CONFIG_PPC */
-
 #include <asm/page.h>
 
 char *of_fdt_get_string(struct boot_param_header *blob, u32 offset)
-- 
1.9.1

