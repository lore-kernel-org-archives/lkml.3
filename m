Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603Ab3GZVWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:22:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832Ab3GZUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:53:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aydin Arik <aydin.arik@alliedtelesis.co.nz>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 19/59] ipv4: Fixed MD5 key lookups when adding/ removing MD5 to/ from TCP sockets.
Date: Fri, 26 Jul 2013 13:52:43 -0700
Message-Id: <20130726205015.867648731@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205013.795696531@linuxfoundation.org>
References: <20130726205013.795696531@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aydin Arik <aydin.arik@alliedtelesis.co.nz>

[ Upstream commit c0353c7b5da4cbd2ab8227e84bbc9c79890f24ce ]

MD5 key lookups on a given TCP socket were being performed
incorrectly. This fix alters parameter inputs to the MD5
lookup function tcp_md5_do_lookup, which is called by functions
tcp_md5_do_add and tcp_md5_do_del. Specifically, the change now
inputs the correct address and address family required to make
a proper lookup.

Signed-off-by: Aydin Arik <aydin.arik@alliedtelesis.co.nz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -974,7 +974,7 @@ int tcp_md5_do_add(struct sock *sk, cons
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_info *md5sig;
 
-	key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)&addr, AF_INET);
+	key = tcp_md5_do_lookup(sk, addr, family);
 	if (key) {
 		/* Pre-existing entry - just update that one. */
 		memcpy(key->key, newkey, newkeylen);
@@ -1019,7 +1019,7 @@ int tcp_md5_do_del(struct sock *sk, cons
 	struct tcp_md5sig_key *key;
 	struct tcp_md5sig_info *md5sig;
 
-	key = tcp_md5_do_lookup(sk, (union tcp_md5_addr *)&addr, AF_INET);
+	key = tcp_md5_do_lookup(sk, addr, family);
 	if (!key)
 		return -ENOENT;
 	hlist_del_rcu(&key->node);


