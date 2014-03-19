Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbaCSHCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:02:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52987 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360AbaCSG43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:56:29 -0400
Message-Id: <20140319065205.060180266@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Mar 2014 07:47:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 24/31] arch,score: Convert smp_mb__*
References: <20140319064729.660482086@infradead.org>
Content-Disposition: inline; filename=peterz-score-smp_mb__atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

score fully relies on asm-generic/barrier.h, so it can use its default
implementation.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/score/include/asm/bitops.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/arch/score/include/asm/bitops.h
+++ b/arch/score/include/asm/bitops.h
@@ -2,12 +2,7 @@
 #define _ASM_SCORE_BITOPS_H
 
 #include <asm/byteorder.h> /* swab32 */
-
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
+#include <asm/barrier.h>
 
 #include <asm-generic/bitops.h>
 #include <asm-generic/bitops/__fls.h>


