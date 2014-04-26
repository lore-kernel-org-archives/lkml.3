Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaDZIsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 04:48:33 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:41413 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbaDZIsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 04:48:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIQANpxW1NXQCJ0/2dsb2JhbABZgwarfwEBAwQBmXECAoEOF3SCZhwjGIECJBOIRQHLBoVaiH+EQAEDjnuKDwGSXIMzOw
Date: Sat, 26 Apr 2014 10:50:31 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] mm/memcontrol.c: remove NULL assignment on static
Message-Id: <20140426105031.84856dc6360dc23bc8039d0f@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static values are automatically initialized to NULL

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 29501f0..6e38542 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -80,7 +80,7 @@ int do_swap_account __read_mostly;
 #ifdef CONFIG_MEMCG_SWAP_ENABLED
 static int really_do_swap_account __initdata = 1;
 #else
-static int really_do_swap_account __initdata = 0;
+static int really_do_swap_account __initdata;
 #endif
 
 #else
@@ -3097,7 +3097,7 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
 char *memcg_create_cache_name(struct mem_cgroup *memcg,
 			      struct kmem_cache *root_cache)
 {
-	static char *buf = NULL;
+	static char *buf;
 
 	/*
 	 * We need a mutex here to protect the shared buffer. Since this is
-- 
1.8.4.5

