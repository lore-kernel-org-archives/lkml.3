Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaKDHMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:12:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbaKDHMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:12:50 -0500
From: Hannes Reinecke <hare@suse.de>
To: linux-nvme@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] nvme: fixup compiler warning
Date: Tue,  4 Nov 2014 08:12:47 +0100
Message-Id: <1415085167-128130-1-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc complains about a variable not initialized properly.

Cc: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/nvme-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index e2bb8af..ff37b9f 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -571,7 +571,7 @@ static int nvme_split_and_submit(struct bio *bio, struct nvme_queue *nvmeq,
 static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 		struct bio *bio, enum dma_data_direction dma_dir, int psegs)
 {
-	struct bio_vec bvec, bvprv;
+	struct bio_vec bvec, bvprv = {.bv_offset = 0, .bv_len = 0};
 	struct bvec_iter iter;
 	struct scatterlist *sg = NULL;
 	int length = 0, nsegs = 0, split_len = bio->bi_iter.bi_size;
-- 
1.8.5.2

