Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3KYNxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:53:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58843 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753509Ab3KYNxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:30 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>, "Jiri Benc" <jbenc@redhat.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.63519382@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 06/87] ipv4: fix ineffective source address selection
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 94cdbc5..12742b8 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2726,7 +2726,7 @@ static struct rtable *ip_route_output_slow(struct net *net, struct flowi4 *fl4)
 							      RT_SCOPE_LINK);
 			goto make_route;
 		}
-		if (fl4->saddr) {
+		if (!fl4->saddr) {
 			if (ipv4_is_multicast(fl4->daddr))
 				fl4->saddr = inet_select_addr(dev_out, 0,
 							      fl4->flowi4_scope);

