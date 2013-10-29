Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab3J2SJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:09:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59604 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab3J2SJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 45/81] net:dccp: do not report ICMP redirects to user space
Date: Tue, 29 Oct 2013 11:04:06 -0700
Message-Id: <1383069882-11437-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

[ Upstream commit bd784a140712fd06674f2240eecfc4ccae421129 ]

DCCP shouldn't be setting sk_err on redirects as it
isn't an error condition. it should be doing exactly
what tcp is doing and leaving the error handler without
touching the socket.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/dccp/ipv6.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 6e05981..f8120c1 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -135,6 +135,7 @@ static void dccp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 		if (dst)
 			dst->ops->redirect(dst, sk, skb);
+		goto out;
 	}
 
 	if (type == ICMPV6_PKT_TOOBIG) {
-- 
1.8.1.2

