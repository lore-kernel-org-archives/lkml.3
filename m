Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab3BMMGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:06:04 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55516 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab3BMMEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:04:46 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 1/5] metag: export metag_code_cache_flush_all
Date: Wed, 13 Feb 2013 12:03:45 +0000
Message-ID: <1360757029-28868-2-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com>
References: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_13_12_04_45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various file systems indirectly use metag_code_cache_flush_all(), so
when they're built as modules we get build errors like the following:

ERROR: "metag_code_cache_flush_all" [fs/xfs/xfs.ko] undefined!

Therefore export this function to modules to fix the errors. This was
hit by a randconfig build.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/mm/cache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/metag/mm/cache.c b/arch/metag/mm/cache.c
index 4dd96e4..b5d3b2e 100644
--- a/arch/metag/mm/cache.c
+++ b/arch/metag/mm/cache.c
@@ -460,6 +460,7 @@ void metag_code_cache_flush_all(const void *start)
 
 	metag_phys_code_cache_flush(start, 4096);
 }
+EXPORT_SYMBOL(metag_code_cache_flush_all);
 
 void metag_code_cache_flush(const void *start, int bytes)
 {
-- 
1.7.7.6


