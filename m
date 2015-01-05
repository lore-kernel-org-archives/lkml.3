Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbbAEMOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:14:53 -0500
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:34514 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751252AbbAEMOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:14:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:966:968:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3868:3871:4250:4321:4385:4605:5007:6261:10004:10400:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229:14093:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wool88_d0435fcd9a5d
X-Filterd-Recvd-Size: 3191
Message-ID: <1420460087.2652.2.camel@perches.com>
Subject: [PATCH] infiniband: Remove duplicated KERN_<LEVEL> from pr_<level>
 uses
From: Joe Perches <joe@perches.com>
To: Roland Dreier <roland@kernel.org>
Cc: Eli Cohen <eli@mellanox.com>, Steve Wise <swise@chelsio.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 05 Jan 2015 04:14:47 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These KERN_<LEVEL> uses are unnecessary and cause
bad logging output so remove them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/cxgb4/device.c | 4 ++--
 drivers/infiniband/hw/mlx4/main.c    | 3 +--
 drivers/infiniband/hw/mlx5/qp.c      | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index eb5df4e..e9e4b2f 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1368,7 +1368,7 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
 					  t4_sq_host_wq_pidx(&qp->wq),
 					  t4_sq_wq_size(&qp->wq));
 		if (ret) {
-			pr_err(KERN_ERR MOD "%s: Fatal error - "
+			pr_err(MOD "%s: Fatal error - "
 			       "DB overflow recovery failed - "
 			       "error syncing SQ qid %u\n",
 			       pci_name(ctx->lldi.pdev), qp->wq.sq.qid);
@@ -1384,7 +1384,7 @@ static void recover_lost_dbs(struct uld_ctx *ctx, struct qp_list *qp_list)
 					  t4_rq_wq_size(&qp->wq));
 
 		if (ret) {
-			pr_err(KERN_ERR MOD "%s: Fatal error - "
+			pr_err(MOD "%s: Fatal error - "
 			       "DB overflow recovery failed - "
 			       "error syncing RQ qid %u\n",
 			       pci_name(ctx->lldi.pdev), qp->wq.rq.qid);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 57ecc5b..6e15136 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1493,8 +1493,7 @@ static void reset_gids_task(struct work_struct *work)
 			       MLX4_CMD_TIME_CLASS_B,
 			       MLX4_CMD_WRAPPED);
 		if (err)
-			pr_warn(KERN_WARNING
-				"set port %d command failed\n", gw->port);
+			pr_warn("set port %d command failed\n", gw->port);
 	}
 
 	mlx4_free_cmd_mailbox(dev, mailbox);
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index be0cd35..e5b4253 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1394,7 +1394,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, const struct ib_ah_attr *ah,
 
 	if (ah->ah_flags & IB_AH_GRH) {
 		if (ah->grh.sgid_index >= gen->port[port - 1].gid_table_len) {
-			pr_err(KERN_ERR "sgid_index (%u) too large. max is %d\n",
+			pr_err("sgid_index (%u) too large. max is %d\n",
 			       ah->grh.sgid_index, gen->port[port - 1].gid_table_len);
 			return -EINVAL;
 		}


