Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbaBEVEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:04:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:54513 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaBEUFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:01 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: stephen hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 054/213] netlink: wake up netlink listeners sooner (v2)
Date: Wed, 5 Feb 2014 15:00:09 -0500
Message-ID: <1391630568-49251-55-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: stephen hemminger <shemminger@vyatta.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2c64580046a122fa15bb586d8ca4fd5e4b69a1e7 upstream.

This patch changes it to yield sooner at halfway instead. Still not a cure-all
for listener overrun if listner is slow, but works much reliably.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index fe6313140563..ba9f6129ff32 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -962,7 +962,7 @@ static inline int netlink_broadcast_deliver(struct sock *sk,
 		skb_set_owner_r(skb, sk);
 		skb_queue_tail(&sk->sk_receive_queue, skb);
 		sk->sk_data_ready(sk, skb->len);
-		return atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf;
+		return atomic_read(&sk->sk_rmem_alloc) > (sk->sk_rcvbuf >> 1);
 	}
 	return -1;
 }
-- 
1.8.5.2

