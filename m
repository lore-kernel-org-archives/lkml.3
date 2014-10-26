Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbaJZJhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 05:37:50 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60359 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaJZJht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 05:37:49 -0400
Message-ID: <1414316264.4290.2.camel@phoenix>
Subject: [PATCH 1/3] soc: ti: Use list_first_entry_or_null() at appropriate
 places
From: Axel Lin <axel.lin@ingics.com>
To: Santosh Shilimkar <ssantosh@kernel.org>
Cc: Sandeep Nair <sandeep_n@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Sun, 26 Oct 2014 17:37:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_first_entry_or_null() for first_region() and first_queue_range().

list_first_entry() expects the list is not empty, so first_region() and
first_queue_range() never return NULL.
Thus use list_first_entry_or_null() instead.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/soc/ti/knav_qmss.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/ti/knav_qmss.h b/drivers/soc/ti/knav_qmss.h
index bc9dcc8..51da234 100644
--- a/drivers/soc/ti/knav_qmss.h
+++ b/drivers/soc/ti/knav_qmss.h
@@ -348,15 +348,15 @@ struct knav_range_info {
 	list_for_each_entry(region, &kdev->regions, list)
 
 #define first_region(kdev)					\
-	list_first_entry(&kdev->regions, \
-			struct knav_region, list)
+	list_first_entry_or_null(&kdev->regions, \
+				 struct knav_region, list)
 
 #define for_each_queue_range(kdev, range)			\
 	list_for_each_entry(range, &kdev->queue_ranges, list)
 
 #define first_queue_range(kdev)					\
-	list_first_entry(&kdev->queue_ranges, \
-			struct knav_range_info, list)
+	list_first_entry_or_null(&kdev->queue_ranges, \
+				 struct knav_range_info, list)
 
 #define for_each_pool(kdev, pool)				\
 	list_for_each_entry(pool, &kdev->pools, list)
-- 
1.9.1



