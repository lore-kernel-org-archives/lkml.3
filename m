Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbaKSWkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:40:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbaKSUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 014/141] ipv6: fix IPV6_PKTINFO with v4 mapped
Date: Wed, 19 Nov 2014 12:50:37 -0800
Message-Id: <20141119205151.142235360@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5337b5b75cd9bd3624a6820e3c2a084d2480061c ]

Use IS_ENABLED(CONFIG_IPV6), to enable this code if IPv6 is
a module.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: c8e6ad0829a7 ("ipv6: honor IPV6_PKTINFO with v4 mapped addresses on sendmsg")
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_sockglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -195,7 +195,7 @@ int ip_cmsg_send(struct net *net, struct
 	for (cmsg = CMSG_FIRSTHDR(msg); cmsg; cmsg = CMSG_NXTHDR(msg, cmsg)) {
 		if (!CMSG_OK(msg, cmsg))
 			return -EINVAL;
-#if defined(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IPV6)
 		if (allow_ipv6 &&
 		    cmsg->cmsg_level == SOL_IPV6 &&
 		    cmsg->cmsg_type == IPV6_PKTINFO) {


