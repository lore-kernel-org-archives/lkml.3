Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966472Ab3DQSUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:20:25 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:10183 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965858Ab3DQSUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:20:20 -0400
X-IronPort-AV: E=Sophos;i="4.87,495,1363132800"; 
   d="scan'208";a="3662948"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v2 1/7] xen-blkback: print stats about persistent grants
Date: Wed, 17 Apr 2013 20:18:55 +0200
Message-ID: <1366222741-39902-2-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1366222741-39902-1-git-send-email-roger.pau@citrix.com>
References: <1366222741-39902-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: xen-devel@lists.xen.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index dd5b2fe..f7526db 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -382,10 +382,12 @@ irqreturn_t xen_blkif_be_int(int irq, void *dev_id)
 static void print_stats(struct xen_blkif *blkif)
 {
 	pr_info("xen-blkback (%s): oo %3llu  |  rd %4llu  |  wr %4llu  |  f %4llu"
-		 "  |  ds %4llu\n",
+		 "  |  ds %4llu | pg: %4u/%4u\n",
 		 current->comm, blkif->st_oo_req,
 		 blkif->st_rd_req, blkif->st_wr_req,
-		 blkif->st_f_req, blkif->st_ds_req);
+		 blkif->st_f_req, blkif->st_ds_req,
+		 blkif->persistent_gnt_c,
+		 max_mapped_grant_pages(blkif->blk_protocol));
 	blkif->st_print = jiffies + msecs_to_jiffies(10 * 1000);
 	blkif->st_rd_req = 0;
 	blkif->st_wr_req = 0;
-- 
1.7.7.5 (Apple Git-26)

