Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3LRVwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:52:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab3LRVMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Veaceslav Falico <veaceslav@falico.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Shawn Landden <shawnlandden@gmail.com>,
        Tom Herbert <therbert@google.com>
Subject: [PATCH 3.10 74/78] Revert "net: update consumers of MSG_MORE to recognize MSG_SENDPAGE_NOTLAST"
Date: Wed, 18 Dec 2013 13:11:42 -0800
Message-Id: <20131218211113.989626427@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

It turns out that commit: d3f7d56a7a4671d395e8af87071068a195257bf6 was
applied to the tree twice, which didn't hurt anything, but it's good to
fix this up.

Reported-by: Veaceslav Falico <veaceslav@falico.eu>

Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Shawn Landden <shawnlandden@gmail.com>
Cc: Tom Herbert <therbert@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/algif_hash.c     |    3 ---
 crypto/algif_skcipher.c |    3 ---
 net/ipv4/udp.c          |    3 ---
 3 files changed, 9 deletions(-)

--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -117,9 +117,6 @@ static ssize_t hash_sendpage(struct sock
 	if (flags & MSG_SENDPAGE_NOTLAST)
 		flags |= MSG_MORE;
 
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
 	lock_sock(sk);
 	sg_init_table(ctx->sgl.sg, 1);
 	sg_set_page(ctx->sgl.sg, page, size, offset);
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -381,9 +381,6 @@ static ssize_t skcipher_sendpage(struct
 	if (flags & MSG_SENDPAGE_NOTLAST)
 		flags |= MSG_MORE;
 
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
 	lock_sock(sk);
 	if (!ctx->more && ctx->used)
 		goto unlock;
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1073,9 +1073,6 @@ int udp_sendpage(struct sock *sk, struct
 	if (flags & MSG_SENDPAGE_NOTLAST)
 		flags |= MSG_MORE;
 
-	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
 	if (!up->pending) {
 		struct msghdr msg = {	.msg_flags = flags|MSG_MORE };
 


