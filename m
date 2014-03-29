Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaC2SCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:02:47 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:40012 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaC2SCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:02:45 -0400
Date: Sat, 29 Mar 2014 23:33:10 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Karen Xie <kxie@chelsio.com>, "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Rashika Kheria <rashika.kheria@gmail.com>, linux-scsi@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 18/55] scsi: Mark function as static in cxgbi/cxgb4i/cxgb4i.c
Message-ID: <5c98327cee53915ce05f252c7683870b814718d1.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in cxgb4i/cxgb4i.c because it is not used
outside this file.

This eliminates the following warning in cxgb4i/cxgb4i.c:
drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:1299:5: warning: no previous prototype for ‘cxgb4i_ofld_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 5a9f842..b84ccef 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1296,7 +1296,7 @@ cxgb4i_cplhandler_func cxgb4i_cplhandlers[NUM_CPL_CMDS] = {
 	[CPL_RX_ISCSI_DDP] = do_rx_data_ddp,
 };
 
-int cxgb4i_ofld_init(struct cxgbi_device *cdev)
+static int cxgb4i_ofld_init(struct cxgbi_device *cdev)
 {
 	int rc;
 
-- 
1.7.9.5

