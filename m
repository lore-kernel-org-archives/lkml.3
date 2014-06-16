Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbaFPSrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:47:48 -0400
Received: from mail-ie0-f193.google.com ([209.85.223.193]:36222 "EHLO
	mail-ie0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaFPSrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:47:46 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: swise@chelsio.com
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2] iw_cxgb4: in send_flowc(), handle a skb return from get_skb()
Date: Mon, 16 Jun 2014 14:47:41 -0400
Message-Id: <1402944461-7940-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 5e153f6..e0c43a3 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -457,6 +457,10 @@ static void send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
 	int i;
 
 	skb = get_skb(skb, flowclen, GFP_KERNEL);
+	if (!skb) {
+		kfree_skb();
+	pr_warn(MOD "%s failed to allocate skb.\n", __func__);
+	}
 	flowc = (struct fw_flowc_wr *)__skb_put(skb, flowclen);
 
 	flowc->op_to_nparams = cpu_to_be32(FW_WR_OP(FW_FLOWC_WR) |
-- 
1.9.1

