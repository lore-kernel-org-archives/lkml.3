Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457Ab3BLVBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:01:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab3BLUgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:36:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tommi Rantala <tt.rantala@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 37/61] ipv6/ip6_gre: fix error case handling in ip6gre_tunnel_xmit()
Date: Tue, 12 Feb 2013 12:34:57 -0800
Message-Id: <20130212203423.137940679@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Tommi Rantala <tt.rantala@gmail.com>

[ Upstream commit 41ab3e31bd50b42c85ac0aa0469642866aee2a9a ]

ip6gre_tunnel_xmit() is leaking the skb when we hit this error branch,
and the -1 return value from this function is bogus. Use the error
handling we already have in place in ip6gre_tunnel_xmit() for this error
case to fix this.

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -976,7 +976,7 @@ static netdev_tx_t ip6gre_tunnel_xmit(st
 	int ret;
 
 	if (!ip6_tnl_xmit_ctl(t))
-		return -1;
+		goto tx_err;
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):


