Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964947Ab3CZQME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:12:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53668 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964929Ab3CZPWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Moore <pmoore@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 043/150] netlabel: correctly list all the static label mappings
Date: Tue, 26 Mar 2013 15:19:02 +0000
Message-Id: <1364311249-14454-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit 0c1233aba1e948c37f6dc7620cb7c253fcd71ce9 upstream.

When we have a large number of static label mappings that spill across
the netlink message boundary we fail to properly save our state in the
netlink_callback struct which causes us to repeat the same listings.
This patch fixes this problem by saving the state correctly between
calls to the NetLabel static label netlink "dumpit" routines.

Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netlabel/netlabel_unlabeled.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index e7ff694..8a0df47 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1250,10 +1250,10 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 
 unlabel_staticlist_return:
 	rcu_read_unlock();
-	cb->args[0] = skip_bkt;
-	cb->args[1] = skip_chain;
-	cb->args[2] = skip_addr4;
-	cb->args[3] = skip_addr6;
+	cb->args[0] = iter_bkt;
+	cb->args[1] = iter_chain;
+	cb->args[2] = iter_addr4;
+	cb->args[3] = iter_addr6;
 	return skb->len;
 }
 
@@ -1320,8 +1320,8 @@ static int netlbl_unlabel_staticlistdef(struct sk_buff *skb,
 
 unlabel_staticlistdef_return:
 	rcu_read_unlock();
-	cb->args[0] = skip_addr4;
-	cb->args[1] = skip_addr6;
+	cb->args[0] = iter_addr4;
+	cb->args[1] = iter_addr6;
 	return skb->len;
 }
 
-- 
1.8.1.2

