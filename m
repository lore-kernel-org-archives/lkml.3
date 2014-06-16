Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbaFPSbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:31:02 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:56572 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496AbaFPSbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:31:00 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: swise@chelsio.com
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] infinibad: fix memory leak in function send_flowc
Date: Mon, 16 Jun 2014 14:30:56 -0400
Message-Id: <1402943456-7532-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 5e153f6..c518411 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -455,7 +455,10 @@ static void send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
 	unsigned int flowclen = 80;
 	struct fw_flowc_wr *flowc;
 	int i;

+	if (!skb) {
+		kfree_skb();
+		pr_warn(MOD "%s failed to allocate skb.\n", __func__);
+	}
 	skb = get_skb(skb, flowclen, GFP_KERNEL);
 	flowc = (struct fw_flowc_wr *)__skb_put(skb, flowclen);
 
-- 
1.9.1

