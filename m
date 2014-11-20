Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaKTG6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:58:48 -0500
Received: from ozlabs.org ([103.22.144.67]:57792 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaKTG6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:58:47 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: tytso@mit.edu
Cc: hpa@linux.intel.com, <linux-kernel@vger.kernel.org>
Subject: [PATCH] random: Remove unused arch_has_random[_seed]()
Date: Thu, 20 Nov 2014 17:58:38 +1100
Message-Id: <1416466718-22718-1-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_has_random() and arch_has_random_seed() were added in 7b878d4b48c4
"random: Add arch_has_random[_seed]()".

arch_has_random() was never used.

arch_has_random_seed() was used in arch_random_refill(), but that usage
was removed in 48d6be955a71 "random: limit the contribution of the hw
rng to at most half".

If they're not used save arch code the trouble of implementing them.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/include/asm/archrandom.h | 9 ---------
 arch/x86/include/asm/archrandom.h     | 3 ---
 include/linux/random.h                | 8 --------
 3 files changed, 20 deletions(-)

diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
index bde531103638..801beba4e64b 100644
--- a/arch/powerpc/include/asm/archrandom.h
+++ b/arch/powerpc/include/asm/archrandom.h
@@ -25,11 +25,6 @@ static inline int arch_get_random_int(unsigned int *v)
 	return rc;
 }
 
-static inline int arch_has_random(void)
-{
-	return !!ppc_md.get_random_long;
-}
-
 int powernv_get_random_long(unsigned long *v);
 
 static inline int arch_get_random_seed_long(unsigned long *v)
@@ -40,10 +35,6 @@ static inline int arch_get_random_seed_int(unsigned int *v)
 {
 	return 0;
 }
-static inline int arch_has_random_seed(void)
-{
-	return 0;
-}
 
 #endif /* CONFIG_ARCH_RANDOM */
 
diff --git a/arch/x86/include/asm/archrandom.h b/arch/x86/include/asm/archrandom.h
index 69f1366f1aa3..6ad7f6d3f97f 100644
--- a/arch/x86/include/asm/archrandom.h
+++ b/arch/x86/include/asm/archrandom.h
@@ -114,9 +114,6 @@ GET_SEED(arch_get_random_seed_int, unsigned int, RDSEED_INT, ASM_NOP4);
 
 #endif /* CONFIG_X86_64 */
 
-#define arch_has_random()	static_cpu_has(X86_FEATURE_RDRAND)
-#define arch_has_random_seed()	static_cpu_has(X86_FEATURE_RDSEED)
-
 #else
 
 static inline int rdrand_long(unsigned long *v)
diff --git a/include/linux/random.h b/include/linux/random.h
index b05856e16b75..6d6e1424184e 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -88,10 +88,6 @@ static inline int arch_get_random_int(unsigned int *v)
 {
 	return 0;
 }
-static inline int arch_has_random(void)
-{
-	return 0;
-}
 static inline int arch_get_random_seed_long(unsigned long *v)
 {
 	return 0;
@@ -100,10 +96,6 @@ static inline int arch_get_random_seed_int(unsigned int *v)
 {
 	return 0;
 }
-static inline int arch_has_random_seed(void)
-{
-	return 0;
-}
 #endif
 
 /* Pseudo random number generator from numerical recipes. */
-- 
1.9.1

