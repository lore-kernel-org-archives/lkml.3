Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3CONzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:55:17 -0400
Received: from multi.imgtec.com ([194.200.65.239]:35783 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410Ab3CONzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:55:14 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3/3] metag: cachepart: fix get_global_dcache_size() typo
Date: Fri, 15 Mar 2013 13:55:03 +0000
Message-ID: <1363355703-23654-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363355703-23654-1-git-send-email-james.hogan@imgtec.com>
References: <1363355703-23654-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_55_12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation is broken when the kernel is destined to live in the global
part of the virtual address space:

arch/metag/kernel/cachepart.c In function 'get_thread_cache_size':
arch/metag/kernel/cachepart.c +71 : error: implicit declaration of function 'get_global_dache_size'

Fix the typo.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/cachepart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/metag/kernel/cachepart.c b/arch/metag/kernel/cachepart.c
index c737edb..954548b 100644
--- a/arch/metag/kernel/cachepart.c
+++ b/arch/metag/kernel/cachepart.c
@@ -67,7 +67,7 @@ static unsigned int get_thread_cache_size(unsigned int cache, int thread_id)
 		return 0;
 #if PAGE_OFFSET >= LINGLOBAL_BASE
 	/* Checking for global cache */
-	cache_size = (cache == DCACHE ? get_global_dache_size() :
+	cache_size = (cache == DCACHE ? get_global_dcache_size() :
 		get_global_icache_size());
 	offset = 8;
 #else
-- 
1.8.1.2


