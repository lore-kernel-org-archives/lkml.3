Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaFPPJE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:09:04 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:62276 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaFPPJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:09:02 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: swise@chelsio.com
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3]Checks for Null value in function *get_skub
Date: Mon, 16 Jun 2014 11:08:57 -0400
Message-Id: <1402931337-3543-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index f9477e2..2d56983 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -340,15 +340,13 @@ static int status2errno(int status)
  */
 static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
 {
 if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
                skb_trim(skb, 0);
                skb_get(skb);
                skb_reset_transport_header(skb);
 	} else {
+		if (skb)
+			kfree (skb);
 		skb = alloc_skb(len, gfp);
 	}
 	t4_set_arp_err_handler(skb, NULL, NULL);
-- 
1.9.1

