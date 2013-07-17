Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526Ab3GQXJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:09:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56724 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934497Ab3GQW4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Kubecek <mkubecek@suse.cz>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 075/145] netfilter: xt_LOG: fix mark logging for IPv6 packets
Date: Wed, 17 Jul 2013 15:46:47 -0700
Message-Id: <1374101277-7915-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

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
index fa40096..ca402a7 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -730,7 +730,7 @@ static void dump_ipv6_packet(struct sbuff *m,
 		dump_sk_uid_gid(m, skb->sk);
 
 	/* Max length: 16 "MARK=0xFFFFFFFF " */
-	if (!recurse && skb->mark)
+	if (recurse && skb->mark)
 		sb_add(m, "MARK=0x%x ", skb->mark);
 }
 
-- 
1.8.1.2

