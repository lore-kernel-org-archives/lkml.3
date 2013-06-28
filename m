Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3F1S5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:57:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41888 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab3F1S5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 089/105] l2tp: Fix sendmsg() return value
Date: Fri, 28 Jun 2013 11:51:51 -0700
Message-Id: <1372445527-24414-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <g.nault@alphalink.fr>

[ Upstream commit a6f79d0f26704214b5b702bbac525cb72997f984 ]

PPPoL2TP sockets should comply with the standard send*() return values
(i.e. return number of bytes sent instead of 0 upon success).

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/l2tp/l2tp_ppp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 88ba2e4..8b875c29 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -357,7 +357,7 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 	sock_put(ps->tunnel_sock);
 	sock_put(sk);
 
-	return error;
+	return total_len;
 
 error_put_sess_tun:
 	sock_put(ps->tunnel_sock);
-- 
1.8.1.2

