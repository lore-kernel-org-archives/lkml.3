Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3BTGl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:41:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41685 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3BTGly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:41:54 -0500
Date: Wed, 20 Feb 2013 01:41:52 -0500 (EST)
Message-Id: <20130220.014152.1773146557292897449.davem@davemloft.net>
To: mroos@ut.ee
Cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org, rientjes@google.com, hannes@cmpxchg.org
Subject: [PATCH 1/3] sparc64: Fix gfp_flags setting in tsb_grow().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Feb 2013 22:41:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We should "|= more_flags" rather than "= more_flags".

Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/mm/tsb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 7f64743..428982b 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -314,7 +314,7 @@ void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
 retry_tsb_alloc:
 	gfp_flags = GFP_KERNEL;
 	if (new_size > (PAGE_SIZE * 2))
-		gfp_flags = __GFP_NOWARN | __GFP_NORETRY;
+		gfp_flags |= __GFP_NOWARN | __GFP_NORETRY;
 
 	new_tsb = kmem_cache_alloc_node(tsb_caches[new_cache_index],
 					gfp_flags, numa_node_id());
-- 
1.8.1.2

