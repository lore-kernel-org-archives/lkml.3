Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaCAUBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 15:01:13 -0500
Received: from mail.ispras.ru ([83.149.199.45]:44970 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbaCAUBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 15:01:11 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Evgeniy Polyakov <zbr@ioremap.net>,
        "David S . Miller" <davem@davemloft.net>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] connector: remove duplicated code in cn_call_callback()
Date: Sun,  2 Mar 2014 00:00:56 +0400
Message-Id: <1393704056-13943-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were a couple of patches fixing the same bug that
results in duplicated err = 0; assignment.
The patch removes one of them.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/connector/connector.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index a36749f1e44a..9b0ea0a6e26e 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -139,7 +139,6 @@ static int cn_call_callback(struct sk_buff *skb)
 	spin_unlock_bh(&dev->cbdev->queue_lock);
 
 	if (cbq != NULL) {
-		err = 0;
 		cbq->callback(msg, nsp);
 		kfree_skb(skb);
 		cn_queue_release_callback(cbq);
-- 
1.8.3.2

