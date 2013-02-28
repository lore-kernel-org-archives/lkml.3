Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3B1Kb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:31:27 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:54669 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3B1K3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:29:39 -0500
X-IronPort-AV: E=Sophos;i="4.84,754,1355097600"; 
   d="scan'208";a="2012287"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH RFC 07/12] xen-blkback: print stats about persistent grants
Date: Thu, 28 Feb 2013 11:28:50 +0100
Message-ID: <1362047335-26402-8-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
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
 drivers/block/xen-blkback/blkback.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index c14b736..b5e7495 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -460,10 +460,11 @@ irqreturn_t xen_blkif_be_int(int irq, void *dev_id)
 static void print_stats(struct xen_blkif *blkif)
 {
 	pr_info("xen-blkback (%s): oo %3d  |  rd %4d  |  wr %4d  |  f %4d"
-		 "  |  ds %4d\n",
+		 "  |  ds %4d | pg: %4d/%4d\n",
 		 current->comm, blkif->st_oo_req,
 		 blkif->st_rd_req, blkif->st_wr_req,
-		 blkif->st_f_req, blkif->st_ds_req);
+		 blkif->st_f_req, blkif->st_ds_req,
+		 blkif->persistent_gnt_c, xen_blkif_max_pgrants);
 	blkif->st_print = jiffies + msecs_to_jiffies(10 * 1000);
 	blkif->st_rd_req = 0;
 	blkif->st_wr_req = 0;
-- 
1.7.7.5 (Apple Git-26)

