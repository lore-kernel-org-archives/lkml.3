Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3KAWEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:04:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3KAWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 06/54] net: do not call sock_put() on TIMEWAIT sockets
Date: Fri,  1 Nov 2013 15:03:34 -0700
Message-Id: <20131101220212.024676233@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 80ad1d61e72d626e30ebe8529a0455e660ca4693 ]

commit 3ab5aee7fe84 ("net: Convert TCP & DCCP hash tables to use RCU /
hlist_nulls") incorrectly used sock_put() on TIMEWAIT sockets.

We should instead use inet_twsk_put()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_hashtables.c  |    2 +-
 net/ipv6/inet6_hashtables.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -287,7 +287,7 @@ begintw:
 			if (unlikely(!INET_TW_MATCH(sk, net, acookie,
 						    saddr, daddr, ports,
 						    dif))) {
-				sock_put(sk);
+				inet_twsk_put(inet_twsk(sk));
 				goto begintw;
 			}
 			goto out;
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -116,7 +116,7 @@ begintw:
 			}
 			if (unlikely(!INET6_TW_MATCH(sk, net, saddr, daddr,
 						     ports, dif))) {
-				sock_put(sk);
+				inet_twsk_put(inet_twsk(sk));
 				goto begintw;
 			}
 			goto out;


