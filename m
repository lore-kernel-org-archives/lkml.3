Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbaJ3SMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:12:19 -0400
Received: from smtprelay0085.hostedemail.com ([216.40.44.85]:34132 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760687AbaJ3SMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:12:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3165:3352:3865:3868:3872:4250:4321:5007:6119:6261:6630:7904:10004:10848:11026:11232:11658:11914:12295:12296:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: play67_69747197aac1a
X-Filterd-Recvd-Size: 2018
From: Joe Perches <joe@perches.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tile: Neaten early_printk uses
Date: Thu, 30 Oct 2014 11:11:53 -0700
Message-Id: <ba879db6b10abf4e356d8765fb23349e56bf6dbd.1414691783.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414691783.git.joe@perches.com>
References: <cover.1414691783.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce the formats and align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/tile/kernel/setup.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index b9736de..6471cc5 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -1208,9 +1208,8 @@ static void __init validate_hv(void)
 	 * We use a struct cpumask for this, so it must be big enough.
 	 */
 	if ((smp_height * smp_width) > nr_cpu_ids)
-		early_panic("Hypervisor %d x %d grid too big for Linux"
-			    " NR_CPUS %d\n", smp_height, smp_width,
-			    nr_cpu_ids);
+		early_panic("Hypervisor %d x %d grid too big for Linux NR_CPUS %d\n",
+			    smp_height, smp_width, nr_cpu_ids);
 #endif
 
 	/*
@@ -1265,10 +1264,9 @@ static void __init validate_va(void)
 
 	/* Kernel PCs must have their high bit set; see intvec.S. */
 	if ((long)VMALLOC_START >= 0)
-		early_panic(
-			"Linux VMALLOC region below the 2GB line (%#lx)!\n"
-			"Reconfigure the kernel with smaller VMALLOC_RESERVE.\n",
-			VMALLOC_START);
+		early_panic("Linux VMALLOC region below the 2GB line (%#lx)!\n"
+			    "Reconfigure the kernel with smaller VMALLOC_RESERVE\n",
+			    VMALLOC_START);
 #endif
 }
 
-- 
2.1.2

