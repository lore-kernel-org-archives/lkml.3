Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaA1Ih7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:37:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbaA1Ihz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:37:55 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org
Subject: [PATCH 07/14] NVMe: Make returning value consistent across all functions
Date: Tue, 28 Jan 2014 09:38:53 +0100
Message-Id: <ee09a5257c25b1c2bf552a1c4fcd1a731a10ec84.1390897693.git.agordeev@redhat.com>
In-Reply-To: <cover.1390897693.git.agordeev@redhat.com>
References: <cover.1390897693.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/block/nvme-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index f03f123..e004c09 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1315,7 +1315,7 @@ static int nvme_create_queue(struct nvme_queue *nvmeq)
 	nvme_init_queue(nvmeq);
 	spin_unlock_irq(&nvmeq->q_lock);
 
-	return result;
+	return 0;
 
  release_sq:
 	adapter_delete_sq(nvmeq);
@@ -1431,7 +1431,7 @@ static int nvme_configure_admin_queue(struct nvme_dev *dev)
 	spin_lock_irq(&nvmeq->q_lock);
 	nvme_init_queue(nvmeq);
 	spin_unlock_irq(&nvmeq->q_lock);
-	return result;
+	return 0;
 }
 
 struct nvme_iod *nvme_map_user_pages(struct nvme_dev *dev, int write,
@@ -2414,7 +2414,7 @@ static int nvme_dev_start(struct nvme_dev *dev)
 	if (result && result != -EBUSY)
 		goto disable;
 
-	return result;
+	return 0;
 
  disable:
 	nvme_disable_queue(dev->queues[0]);
-- 
1.7.7.6

