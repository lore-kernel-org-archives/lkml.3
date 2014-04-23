Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaDWBTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:19:15 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47585 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaDWBTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:19:09 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
Subject: [PATCH v2 16/21] of/fdt: fix phys_addr_t related print size warnings
Date: Tue, 22 Apr 2014 20:18:16 -0500
Message-Id: <1398215901-25609-17-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
References: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Fix warnings in early_init_dt_reserve_memory_arch when phys_addr_t is
32-bit and memblock is not enabled.

Signed-off-by: Rob Herring <robh@kernel.org>
---
v2: New patch

 drivers/of/fdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 051be4c..d9e6450 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -852,8 +852,8 @@ void * __init __weak early_init_dt_alloc_memory_arch(u64 size, u64 align)
 int __init __weak early_init_dt_reserve_memory_arch(phys_addr_t base,
 					phys_addr_t size, bool nomap)
 {
-	pr_err("Reserved memory not supported, ignoring range 0x%llx - 0x%llx%s\n",
-		  base, size, nomap ? " (nomap)" : "");
+	pr_err("Reserved memory not supported, ignoring range 0x%pa - 0x%pa%s\n",
+		  &base, &size, nomap ? " (nomap)" : "");
 	return -ENOSYS;
 }
 #endif
-- 
1.9.1

