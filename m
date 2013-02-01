Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3BAL6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:58:23 -0500
Received: from multi.imgtec.com ([194.200.65.239]:31910 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab3BAL6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:58:19 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/6] metag: add __init to metag_cache_probe()
Date: Fri, 1 Feb 2013 11:49:05 +0000
Message-ID: <1359719350-24560-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
References: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_01_11_58_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

metag_cache_probe() is only called from setup_arch(), so add the __init
attribute to it.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/mm/cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/metag/mm/cache.c b/arch/metag/mm/cache.c
index b713ec0..89da74a 100644
--- a/arch/metag/mm/cache.c
+++ b/arch/metag/mm/cache.c
@@ -42,7 +42,7 @@ static unsigned char icache_sets_log2 = DEFAULT_CACHE_WAYS_LOG2;
  * Probe the L1 cache configuration to aid the L1 physical cache flushing
  * functions.
  */
-void metag_cache_probe(void)
+void __init metag_cache_probe(void)
 {
 #ifndef CONFIG_METAG_META12
 	int coreid = metag_in32(METAC_CORE_ID);
-- 
1.7.7.6


