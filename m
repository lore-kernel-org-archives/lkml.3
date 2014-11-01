Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbaKAFdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 01:33:18 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61176 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaKAFdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 01:33:17 -0400
Message-ID: <1414819993.23500.1.camel@phoenix>
Subject: [PATCH] soc: ti: knav_qmss_queue: Use list_for_each_entry_safe to
 prevent use after free
From: Axel Lin <axel.lin@ingics.com>
To: Santosh Shilimkar <ssantosh@kernel.org>
Cc: Sandeep Nair <sandeep_n@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Sat, 01 Nov 2014 13:33:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_for_each_entry_safe() is necessary if list objects are deleted from
the list while traversing it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/soc/ti/knav_qmss_queue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
index 6f22d56..9b8dd67 100644
--- a/drivers/soc/ti/knav_qmss_queue.c
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -1306,14 +1306,14 @@ static void knav_free_queue_ranges(struct knav_device *kdev)
 static void knav_queue_free_regions(struct knav_device *kdev)
 {
 	struct knav_region *region;
-	struct knav_pool *pool;
+	struct knav_pool *pool, *tmp;
 	unsigned size;
 
 	for (;;) {
 		region = first_region(kdev);
 		if (!region)
 			break;
-		list_for_each_entry(pool, &region->pools, region_inst)
+		list_for_each_entry_safe(pool, tmp, &region->pools, region_inst)
 			knav_pool_destroy(pool);
 
 		size = region->virt_end - region->virt_start;
-- 
1.9.1



