Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbaCBVNi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 16:13:38 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:39968 "EHLO frisell.zx2c4.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbaCBVNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 16:13:35 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Mar 2014 16:13:34 EST
DomainKey-Signature: a=rsa-sha1; c=nofws; d=zx2c4.com; h=from:to:cc
	:subject:date:message-id; q=dns; s=mail; b=iIAE1fBWhhGnWrGwam5h3
	BKWuf0jA8ft/xiHs+o3xHsyGgLd/a96vKSWicPQ6Wmqsjy0676kIUAW96bw2mw5k
	q9gayK+dfW3QSVwDiQwAnzpLYdiWlMZ9bl+aUtAkO5RCqz1izaSZKy97UUfvkB/A
	xH9lRmmAPE0CZkwMlJQJPA=
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] ip_set: remove extraneous log message
Date: Sun,  2 Mar 2014 22:07:04 +0100
Message-Id: <1393794424-1887-1-git-send-email-Jason@zx2c4.com>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code path is hit everytime a new network namespace is created,
which means it runs everytime I start Chromium, resulting in needless
noise in my logs. This message doesn't add very much at all, and isn't
triggered at the correct place anyway, so this patch simply removes it.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/netfilter/ipset/ip_set_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index de770ec..283f197 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1945,7 +1945,6 @@ ip_set_net_init(struct net *net)
 		return -ENOMEM;
 	inst->is_deleted = 0;
 	rcu_assign_pointer(inst->ip_set_list, list);
-	pr_notice("ip_set: protocol %u\n", IPSET_PROTOCOL);
 	return 0;
 }
 
-- 
1.8.5.4

