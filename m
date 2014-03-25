Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaCYXvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:51:09 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36921 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbaCYXtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:49:12 -0400
From: Gwendal Grignou <gwendal@chromium.org>
To: axboe@kernel.dk, ulf.hansson@linaro.org
Cc: linux-mtd@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH 4/4] Limit max_discard_sectors to UINT_MAX>>9
Date: Tue, 25 Mar 2014 16:48:26 -0700
Message-Id: <1395791307-23727-5-git-send-email-gwendal@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1395791307-23727-1-git-send-email-gwendal@chromium.org>
References: <1395791307-23727-1-git-send-email-gwendal@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_discard_sectors can not be larger than UINT_MAX>>9,
otherwise, there is a risk that discard requests would be merged
into a request larger than 4GB.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 drivers/mtd/mtd_blkdevs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 5073cbc..e74090c 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -416,7 +416,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 
 	if (tr->discard) {
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, new->rq);
-		new->rq->limits.max_discard_sectors = UINT_MAX;
+		new->rq->limits.max_discard_sectors = UINT_MAX >> 9;
 	}
 
 	gd->queue = new->rq;
-- 
1.9.1.423.g4596e3a

