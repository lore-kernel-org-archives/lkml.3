Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbaFPC02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 22:26:28 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:63449 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaFPC0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 22:26:25 -0400
From: Nick <xerofoify@gmail.com>
To: swise@chelsio.com
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix memory leak in cm.c
Date: Sun, 15 Jun 2014 22:26:19 -0400
Message-Id: <1402885579-2994-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes memory by checking in function,
*get_skuff if it is be passing a Null skb
struct.
Cheers Nick 
Signed-off-by: Nick <xerofoify@gmail.com>
---
 drivers/infiniband/hw/cxgb4/cm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 5e153f6..f9477e2 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -340,7 +340,11 @@ static int status2errno(int status)
  */
 static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
 {
-	if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
+	if (!skb) {
+		return NULL;
+	}
+
+	else if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
 		skb_trim(skb, 0);
 		skb_get(skb);
 		skb_reset_transport_header(skb);
-- 
1.9.1

