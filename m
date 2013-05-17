Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3EQOKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 10:10:04 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:32890 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab3EQOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 10:10:00 -0400
From: Emil Goode <emilgoode@gmail.com>
To: willy@linux.intel.com, keith.busch@intel.com, vishal.l.verma@intel.com
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] NVMe: Fix incompatible pointer type warnings
Date: Fri, 17 May 2013 16:09:40 +0200
Message-Id: <1368799780-2871-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6a4d55146334 ("block: prep work for batch completion")
added a struct batch_complete * as a third argument to bi_end_io.
This patch adds the missing third argument to the nvme_bio_pair_endio
function.

Sparse output:

drivers/block/nvme-core.c: In function ‘nvme_bio_split’:
drivers/block/nvme-core.c:483:19: warning:
	assignment from incompatible pointer type [enabled by default]
drivers/block/nvme-core.c:484:19: warning:
	assignment from incompatible pointer type [enabled by default]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/block/nvme-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 8efdfaa..9380133 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -413,7 +413,8 @@ struct nvme_bio_pair {
 	atomic_t cnt;
 };
 
-static void nvme_bio_pair_endio(struct bio *bio, int err)
+static void nvme_bio_pair_endio(struct bio *bio, int err,
+						struct batch_complete *batch)
 {
 	struct nvme_bio_pair *bp = bio->bi_private;
 
-- 
1.7.10.4

