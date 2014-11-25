Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaKYKxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:53:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59130 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbaKYKn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 223/254] ipv6: fix IPV6_PKTINFO with v4 mapped
Date: Tue, 25 Nov 2014 10:39:33 +0000
Message-Id: <1416912004-5928-224-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 5337b5b75cd9bd3624a6820e3c2a084d2480061c upstream.

Use IS_ENABLED(CONFIG_IPV6), to enable this code if IPv6 is
a module.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: c8e6ad0829a7 ("ipv6: honor IPV6_PKTINFO with v4 mapped addresses on sendmsg")
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ip_sockglue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 64741b938632..94f1f15cf834 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -195,7 +195,7 @@ int ip_cmsg_send(struct net *net, struct msghdr *msg, struct ipcm_cookie *ipc,
 	for (cmsg = CMSG_FIRSTHDR(msg); cmsg; cmsg = CMSG_NXTHDR(msg, cmsg)) {
 		if (!CMSG_OK(msg, cmsg))
 			return -EINVAL;
-#if defined(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IPV6)
 		if (allow_ipv6 &&
 		    cmsg->cmsg_level == SOL_IPV6 &&
 		    cmsg->cmsg_type == IPV6_PKTINFO) {
-- 
2.1.0

