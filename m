Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab3GKO0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:26:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43025 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab3GKO0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Kubecek <mkubecek@suse.cz>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 43/98] netfilter: xt_LOG: fix mark logging for IPv6 packets
Date: Thu, 11 Jul 2013 15:24:13 +0100
Message-Id: <1373552708-15235-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Michal=20Kube=C4=8Dek?= <mkubecek@suse.cz>

commit d660164d79b67f879db35a7d61e47d3b99bc714e upstream.

In dump_ipv6_packet(), the "recurse" parameter is zero only if
dumping contents of a packet embedded into an ICMPv6 error
message. Therefore we want to log packet mark if recurse is
non-zero, not when it is zero.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/xt_LOG.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index ff5f75f..a2e878f 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -727,7 +727,7 @@ static void dump_ipv6_packet(struct sbuff *m,
 	}
 
 	/* Max length: 16 "MARK=0xFFFFFFFF " */
-	if (!recurse && skb->mark)
+	if (recurse && skb->mark)
 		sb_add(m, "MARK=0x%x ", skb->mark);
 }
 
-- 
1.8.1.2

