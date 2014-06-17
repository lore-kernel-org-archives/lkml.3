Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411AbaFQPYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:24:40 -0400
Received: from mail-ig0-f196.google.com ([209.85.213.196]:57652 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112AbaFQPYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:24:38 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: swise@chelsio.com
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Checks for Null return of skb_alloc in send_flowc
Date: Tue, 17 Jun 2014 11:24:33 -0400
Message-Id: <1403018673-4819-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 5e153f6..7e3d663 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -457,6 +457,10 @@ static void send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
 	int i;
 
 	skb = get_skb(skb, flowclen, GFP_KERNEL);
+	if (!skb) {
+		kfree_skb(skb);
+		pr_warn(MOD "%s failed to allocate skb.\n", __func__);
+	}
 	flowc = (struct fw_flowc_wr *)__skb_put(skb, flowclen);
 
 	flowc->op_to_nparams = cpu_to_be32(FW_WR_OP(FW_FLOWC_WR) |
-- 
1.9.1

