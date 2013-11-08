Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab3KHCS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:18:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34678 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab3KHCSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:18:47 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Benc <jbenc@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 20/91] ipv4: fix ineffective source address selection
Date: Thu,  7 Nov 2013 18:14:35 -0800
Message-Id: <1383876946-2396-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 0a7e22609067ff524fc7bbd45c6951dd08561667 ]

When sending out multicast messages, the source address in inet->mc_addr is
ignored and rewritten by an autoselected one. This is caused by a typo in
commit 813b3b5db831 ("ipv4: Use caller's on-stack flowi as-is in output
route lookups").

Signed-off-by: Jiri Benc <jbenc@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 70da494..0bf88e4 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2024,7 +2024,7 @@ struct rtable *__ip_route_output_key(struct net *net, struct flowi4 *fl4)
 							      RT_SCOPE_LINK);
 			goto make_route;
 		}
-		if (fl4->saddr) {
+		if (!fl4->saddr) {
 			if (ipv4_is_multicast(fl4->daddr))
 				fl4->saddr = inet_select_addr(dev_out, 0,
 							      fl4->flowi4_scope);
-- 
1.8.1.2

