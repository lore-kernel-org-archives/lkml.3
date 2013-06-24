Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab3FXMuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:50:02 -0400
Received: from multi.imgtec.com ([194.200.65.239]:2050 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab3FXMt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:49:59 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 2/2] metag: don't check for cache aliasing on smp cpu boot
Date: Mon, 24 Jun 2013 13:49:48 +0100
Message-ID: <1372078188-26602-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372078188-26602-1-git-send-email-james.hogan@imgtec.com>
References: <1372078188-26602-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_24_13_49_58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cache configuration of the boot cpu is now duplicated to secondary
cpus, so there's no need to check for cache aliasing again when a
secondary cpu is booted. Therefore remove the check from
secondary_start_kernel().

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/kernel/smp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
index f443ec9..86fdda4 100644
--- a/arch/metag/kernel/smp.c
+++ b/arch/metag/kernel/smp.c
@@ -404,12 +404,6 @@ asmlinkage void secondary_start_kernel(void)
 	set_cpu_online(cpu, true);
 
 	/*
-	 * Check for cache aliasing.
-	 * Preemption is disabled
-	 */
-	check_for_cache_aliasing(cpu);
-
-	/*
 	 * OK, it's off to the idle thread for us
 	 */
 	cpu_startup_entry(CPUHP_ONLINE);
-- 
1.8.1.2


