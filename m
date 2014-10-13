Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaJMC50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:57:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaJMC0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:26:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [PATCH 3.14 16/37] ipv6: restore the behavior of ipv6_sock_ac_drop()
Date: Mon, 13 Oct 2014 04:24:13 +0200
Message-Id: <20141013022400.980912864@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WANG Cong <xiyou.wangcong@gmail.com>

[ Upstream commit de185ab46cb02df9738b0d898b0c3a89181c5526 ]

It is possible that the interface is already gone after joining
the list of anycast on this interface as we don't hold a refcount
for the device, in this case we are safe to ignore the error.

What's more important, for API compatibility we should not
change this behavior for applications even if it were correct.

Fixes: commit a9ed4a2986e13011 ("ipv6: fix rtnl locking in setsockopt for anycast and multicast")
Cc: Sabrina Dubroca <sd@queasysnail.net>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/anycast.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -182,8 +182,6 @@ int ipv6_sock_ac_drop(struct sock *sk, i
 	rtnl_unlock();
 
 	sock_kfree_s(sk, pac, sizeof(*pac));
-	if (!dev)
-		return -ENODEV;
 	return 0;
 }
 


