Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaBMKDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 05:03:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaBMKDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:03:00 -0500
From: Daniel Borkmann <dborkman@redhat.com>
To: akpm@linux-foundation.org
Cc: joe@perches.com, linux-kernel@vger.kernel.org
Subject: [PATCH akpm-next v2] random32: minor cleanups and kdoc fix
Date: Thu, 13 Feb 2014 11:02:56 +0100
Message-Id: <1392285776-27949-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are just some very minor and misc cleanups in the PRNG. In
prandom_u32() we store the result in an unsigned long which is
unnecessary as it should be u32 instead that we get from
prandom_u32_state(). prandom_bytes_state()'s comment is in kdoc
format, so change it into such as it's done everywhere else.
Also, use the normal comment style for the header comment. Last
but not least for readability, add some newlines.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 v1->v2:
  - Applied most of Joe's feedback

 lib/random32.c | 76 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 39 insertions(+), 37 deletions(-)

diff --git a/lib/random32.c b/lib/random32.c
index 1e5b2df..b33b23e 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -1,37 +1,35 @@
 /*
-  This is a maximally equidistributed combined Tausworthe generator
-  based on code from GNU Scientific Library 1.5 (30 Jun 2004)
-
-  lfsr113 version:
-
-   x_n = (s1_n ^ s2_n ^ s3_n ^ s4_n)
-
-   s1_{n+1} = (((s1_n & 4294967294) << 18) ^ (((s1_n <<  6) ^ s1_n) >> 13))
-   s2_{n+1} = (((s2_n & 4294967288) <<  2) ^ (((s2_n <<  2) ^ s2_n) >> 27))
-   s3_{n+1} = (((s3_n & 4294967280) <<  7) ^ (((s3_n << 13) ^ s3_n) >> 21))
-   s4_{n+1} = (((s4_n & 4294967168) << 13) ^ (((s4_n <<  3) ^ s4_n) >> 12))
-
-   The period of this generator is about 2^113 (see erratum paper).
-
-   From: P. L'Ecuyer, "Maximally Equidistributed Combined Tausworthe
-   Generators", Mathematics of Computation, 65, 213 (1996), 203--213:
-   http://www.iro.umontreal.ca/~lecuyer/myftp/papers/tausme.ps
-   ftp://ftp.iro.umontreal.ca/pub/simulation/lecuyer/papers/tausme.ps
-
-   There is an erratum in the paper "Tables of Maximally
-   Equidistributed Combined LFSR Generators", Mathematics of
-   Computation, 68, 225 (1999), 261--269:
-   http://www.iro.umontreal.ca/~lecuyer/myftp/papers/tausme2.ps
-
-        ... the k_j most significant bits of z_j must be non-
-        zero, for each j. (Note: this restriction also applies to the
-        computer code given in [4], but was mistakenly not mentioned in
-        that paper.)
-
-   This affects the seeding procedure by imposing the requirement
-   s1 > 1, s2 > 7, s3 > 15, s4 > 127.
-
-*/
+ * This is a maximally equidistributed combined Tausworthe generator
+ * based on code from GNU Scientific Library 1.5 (30 Jun 2004)
+ *
+ * lfsr113 version:
+ *
+ * x_n = (s1_n ^ s2_n ^ s3_n ^ s4_n)
+ *
+ * s1_{n+1} = (((s1_n & 4294967294) << 18) ^ (((s1_n <<  6) ^ s1_n) >> 13))
+ * s2_{n+1} = (((s2_n & 4294967288) <<  2) ^ (((s2_n <<  2) ^ s2_n) >> 27))
+ * s3_{n+1} = (((s3_n & 4294967280) <<  7) ^ (((s3_n << 13) ^ s3_n) >> 21))
+ * s4_{n+1} = (((s4_n & 4294967168) << 13) ^ (((s4_n <<  3) ^ s4_n) >> 12))
+ *
+ * The period of this generator is about 2^113 (see erratum paper).
+ *
+ * From: P. L'Ecuyer, "Maximally Equidistributed Combined Tausworthe
+ * Generators", Mathematics of Computation, 65, 213 (1996), 203--213:
+ * http://www.iro.umontreal.ca/~lecuyer/myftp/papers/tausme.ps
+ * ftp://ftp.iro.umontreal.ca/pub/simulation/lecuyer/papers/tausme.ps
+ *
+ * There is an erratum in the paper "Tables of Maximally Equidistributed
+ * Combined LFSR Generators", Mathematics of Computation, 68, 225 (1999),
+ * 261--269: http://www.iro.umontreal.ca/~lecuyer/myftp/papers/tausme2.ps
+ *
+ *      ... the k_j most significant bits of z_j must be non-zero,
+ *      for each j. (Note: this restriction also applies to the
+ *      computer code given in [4], but was mistakenly not mentioned
+ *      in that paper.)
+ *
+ * This affects the seeding procedure by imposing the requirement
+ * s1 > 1, s2 > 7, s3 > 15, s4 > 127.
+ */
 
 #include <linux/types.h>
 #include <linux/percpu.h>
@@ -75,15 +73,17 @@ EXPORT_SYMBOL(prandom_u32_state);
  */
 u32 prandom_u32(void)
 {
-	unsigned long r;
 	struct rnd_state *state = &get_cpu_var(net_rand_state);
-	r = prandom_u32_state(state);
+	u32 res;
+
+	res = prandom_u32_state(state);
 	put_cpu_var(state);
-	return r;
+
+	return res;
 }
 EXPORT_SYMBOL(prandom_u32);
 
-/*
+/**
  *	prandom_bytes_state - get the requested number of pseudo-random bytes
  *
  *	@state: pointer to state structure holding seeded state.
@@ -204,6 +204,7 @@ static int __init prandom_init(void)
 		prandom_seed_very_weak(state, (i + jiffies) ^ random_get_entropy());
 		prandom_warmup(state);
 	}
+
 	return 0;
 }
 core_initcall(prandom_init);
@@ -248,6 +249,7 @@ static void __prandom_reseed(bool late)
 	spin_lock_irqsave(&lock, flags);
 	if (latch && !late)
 		goto out;
+
 	latch = true;
 
 	for_each_possible_cpu(i) {
-- 
1.7.11.7

