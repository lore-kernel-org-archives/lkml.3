Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbaIOWYC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:24:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51353 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109AbaIOWUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wen Xiong <wenxiong@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Whitcroft <apw@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 046/187] bnx2x: Adapter not recovery from EEH error injection
Date: Mon, 15 Sep 2014 15:07:36 -0700
Message-Id: <1410818997-9432-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "wenxiong@linux.vnet.ibm.com" <wenxiong@linux.vnet.ibm.com>

commit 0c0e63410a393aae4b615849625f539db775d586 upstream.

When injecting EEH error to bnx2x adapter, adapter couldn't be recovery
and caused recursive EEH errors. The patch fixes the issue.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 0067b97..71d3f0c 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12998,8 +12998,8 @@ static int bnx2x_eeh_nic_unload(struct bnx2x *bp)
 	netdev_reset_tc(bp->dev);
 
 	del_timer_sync(&bp->timer);
-	cancel_delayed_work(&bp->sp_task);
-	cancel_delayed_work(&bp->period_task);
+	cancel_delayed_work_sync(&bp->sp_task);
+	cancel_delayed_work_sync(&bp->period_task);
 
 	spin_lock_bh(&bp->stats_lock);
 	bp->stats_state = STATS_STATE_DISABLED;
-- 
1.9.1

