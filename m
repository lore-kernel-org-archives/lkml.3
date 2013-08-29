Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3H2NpC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:45:02 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59811 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab3H2NpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:45:00 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Wladislav Wiebe <wladislav.kw@gmail.com>
Subject: [PATCH] of/fdt: Remove duplicate memory clearing on FDT unflattening
Date: Thu, 29 Aug 2013 14:44:52 +0100
Message-Id: <1377783892-13226-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 9e4012752, "of: fdt: fix memory initialization for expanded DT"
fixed incomplete clearing of memory when unflattening the device tree.
However the code was already clearing some of the memory, it just wasn't
doing so for all allocations. Now that the memory is cleared right at
the point of allocation, the memset after unflatten_dt_alloc() is
redundant. Remove it.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Wladislav Wiebe <wladislav.kw@gmail.com>
---
 drivers/of/fdt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 55b028f..9d9be9617 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -202,7 +202,6 @@ static void * unflatten_dt_node(struct boot_param_header *blob,
 				__alignof__(struct device_node));
 	if (allnextpp) {
 		char *fn;
-		memset(np, 0, sizeof(*np));
 		np->full_name = fn = ((char *)np) + sizeof(*np);
 		if (new_format) {
 			/* rebuild full path for new format */
-- 
1.8.1.2

