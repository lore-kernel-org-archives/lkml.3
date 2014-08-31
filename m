Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaHaUly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 16:41:54 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40004 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaHaUlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 16:41:52 -0400
From: Ramon Fried <ramon.fried@gmail.com>
To: gregkh@linuxfoundation.org, ganesanr@broadcom.com
Cc: jchandra@broadcom.com, linux-kernel@vger.kernel.org,
        Ramon Fried <ramon.fried@gmail.com>
Subject: [PATCH] staging: netlogic: Fix checkpatch.pl warning
Date: Sun, 31 Aug 2014 23:40:29 +0300
Message-Id: <1409517629-8004-1-git-send-email-ramon.fried@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning:

WARNING: Possible unnecessary 'out of memory' message
#116: FILE: ./xlr_net.c:116:
+	if (!skb) {
+		pr_err("SKB allocation failed\n");

Signed-off-by: Ramon Fried <ramon.fried@gmail.com>
---
 drivers/staging/netlogic/xlr_net.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index f8120fe..3f9c5ad 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -112,10 +112,8 @@ static inline unsigned char *xlr_alloc_skb(void)
 
 	/* skb->data is cache aligned */
 	skb = alloc_skb(XLR_RX_BUF_SIZE, GFP_ATOMIC);
-	if (!skb) {
-		pr_err("SKB allocation failed\n");
+	if (!skb)
 		return NULL;
-	}
 	skb_data = skb->data;
 	skb_put(skb, MAC_SKB_BACK_PTR_SIZE);
 	skb_pull(skb, MAC_SKB_BACK_PTR_SIZE);
-- 
1.9.1

