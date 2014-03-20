Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbaCTOjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:39:16 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50504 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbaCTOjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:39:14 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eddie.wai@broadcom.com,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH 1/9] net/ethernet: Replace rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL) in drivers/net/ethernet/broadcom/bnx2.c
Date: Thu, 20 Mar 2014 20:08:19 +0530
Message-Id: <1965df1cea51fc4c08e563554739fb74bbcaf58e.1395324808.git.monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1395324808.git.monamagarwal123@gmail.com>
References: <cover.1395324808.git.monamagarwal123@gmail.com>
In-Reply-To: <cover.1395324808.git.monamagarwal123@gmail.com>
References: <cover.1395324808.git.monamagarwal123@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/net/ethernet/broadcom/bnx2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 965c723..5eab730 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -409,7 +409,7 @@ static int bnx2_unregister_cnic(struct net_device *dev)
 	mutex_lock(&bp->cnic_lock);
 	cp->drv_state = 0;
 	bnapi->cnic_present = 0;
-	rcu_assign_pointer(bp->cnic_ops, NULL);
+	RCU_INIT_POINTER(bp->cnic_ops, NULL);
 	mutex_unlock(&bp->cnic_lock);
 	synchronize_rcu();
 	return 0;
-- 
1.7.9.5

