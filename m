Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaFWItI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:49:08 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55577 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 087/111] netlink: Rename netlink_capable netlink_allowed
Date: Mon, 23 Jun 2014 10:32:02 +0200
Message-Id: <4587dcd284963b76844da9932f6440aa312aec0a.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 5187cd055b6e81fc6526109456f8b20623148d5f ]

netlink_capable is a static internal function in af_netlink.c and we
have better uses for the name netlink_capable.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/netlink/af_netlink.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 613563555515..70629017eae3 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1352,7 +1352,7 @@ retry:
 	return err;
 }
 
-static inline int netlink_capable(const struct socket *sock, unsigned int flag)
+static inline int netlink_allowed(const struct socket *sock, unsigned int flag)
 {
 	return (nl_table[sock->sk->sk_protocol].flags & flag) ||
 		ns_capable(sock_net(sock->sk)->user_ns, CAP_NET_ADMIN);
@@ -1420,7 +1420,7 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 
 	/* Only superuser is allowed to listen multicasts */
 	if (nladdr->nl_groups) {
-		if (!netlink_capable(sock, NL_CFG_F_NONROOT_RECV))
+		if (!netlink_allowed(sock, NL_CFG_F_NONROOT_RECV))
 			return -EPERM;
 		err = netlink_realloc_groups(sk);
 		if (err)
@@ -1482,7 +1482,7 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 		return -EINVAL;
 
 	/* Only superuser is allowed to send multicasts */
-	if (nladdr->nl_groups && !netlink_capable(sock, NL_CFG_F_NONROOT_SEND))
+	if (nladdr->nl_groups && !netlink_allowed(sock, NL_CFG_F_NONROOT_SEND))
 		return -EPERM;
 
 	if (!nlk->portid)
@@ -2088,7 +2088,7 @@ static int netlink_setsockopt(struct socket *sock, int level, int optname,
 		break;
 	case NETLINK_ADD_MEMBERSHIP:
 	case NETLINK_DROP_MEMBERSHIP: {
-		if (!netlink_capable(sock, NL_CFG_F_NONROOT_RECV))
+		if (!netlink_allowed(sock, NL_CFG_F_NONROOT_RECV))
 			return -EPERM;
 		err = netlink_realloc_groups(sk);
 		if (err)
@@ -2239,7 +2239,7 @@ static int netlink_sendmsg(struct kiocb *kiocb, struct socket *sock,
 		dst_group = ffs(addr->nl_groups);
 		err =  -EPERM;
 		if ((dst_group || dst_portid) &&
-		    !netlink_capable(sock, NL_CFG_F_NONROOT_SEND))
+		    !netlink_allowed(sock, NL_CFG_F_NONROOT_SEND))
 			goto out;
 	} else {
 		dst_portid = nlk->dst_portid;
-- 
2.0.0

