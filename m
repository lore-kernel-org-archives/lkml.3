Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaFXPxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:53:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbaFXPxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:53:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 07/68] netlink: Rename netlink_capable netlink_allowed
Date: Tue, 24 Jun 2014 11:50:26 -0400
Message-Id: <20140624154724.253832788@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 5187cd055b6e81fc6526109456f8b20623148d5f ]

netlink_capable is a static internal function in af_netlink.c and we
have better uses for the name netlink_capable.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1360,7 +1360,7 @@ retry:
 	return err;
 }
 
-static inline int netlink_capable(const struct socket *sock, unsigned int flag)
+static inline int netlink_allowed(const struct socket *sock, unsigned int flag)
 {
 	return (nl_table[sock->sk->sk_protocol].flags & flag) ||
 		ns_capable(sock_net(sock->sk)->user_ns, CAP_NET_ADMIN);
@@ -1428,7 +1428,7 @@ static int netlink_bind(struct socket *s
 
 	/* Only superuser is allowed to listen multicasts */
 	if (nladdr->nl_groups) {
-		if (!netlink_capable(sock, NL_CFG_F_NONROOT_RECV))
+		if (!netlink_allowed(sock, NL_CFG_F_NONROOT_RECV))
 			return -EPERM;
 		err = netlink_realloc_groups(sk);
 		if (err)
@@ -1490,7 +1490,7 @@ static int netlink_connect(struct socket
 		return -EINVAL;
 
 	if ((nladdr->nl_groups || nladdr->nl_pid) &&
-	    !netlink_capable(sock, NL_CFG_F_NONROOT_SEND))
+	    !netlink_allowed(sock, NL_CFG_F_NONROOT_SEND))
 		return -EPERM;
 
 	if (!nlk->portid)
@@ -2096,7 +2096,7 @@ static int netlink_setsockopt(struct soc
 		break;
 	case NETLINK_ADD_MEMBERSHIP:
 	case NETLINK_DROP_MEMBERSHIP: {
-		if (!netlink_capable(sock, NL_CFG_F_NONROOT_RECV))
+		if (!netlink_allowed(sock, NL_CFG_F_NONROOT_RECV))
 			return -EPERM;
 		err = netlink_realloc_groups(sk);
 		if (err)
@@ -2247,7 +2247,7 @@ static int netlink_sendmsg(struct kiocb
 		dst_group = ffs(addr->nl_groups);
 		err =  -EPERM;
 		if ((dst_group || dst_portid) &&
-		    !netlink_capable(sock, NL_CFG_F_NONROOT_SEND))
+		    !netlink_allowed(sock, NL_CFG_F_NONROOT_SEND))
 			goto out;
 	} else {
 		dst_portid = nlk->dst_portid;


