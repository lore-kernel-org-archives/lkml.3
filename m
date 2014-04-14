Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbaDNRzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:55:55 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:64350 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaDNRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:55:53 -0400
MIME-Version: 1.0
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 14 Apr 2014 13:55:21 -0400
Message-ID: <CAJhHMCDBPPB4H3Oc1JVd_R_dMaao9cWBj8rjrweFmAp9nn97AQ@mail.gmail.com>
Subject: [PATCH 1/1] prefetch result for ARM64 atomic ops
To: catalin.marinas@arm.com, will.deacon@arm.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/arm64/include/asm/atomic.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/atomic.h b/arch/arm64/include/asm/atomic.h
index 0237f08..82271ee 100644
--- a/arch/arm64/include/asm/atomic.h
+++ b/arch/arm64/include/asm/atomic.h
@@ -48,6 +48,7 @@ static inline void atomic_add(int i, atomic_t *v)
     unsigned long tmp;
     int result;

+    prefetchw(&v->counter);
     asm volatile("// atomic_add\n"
 "1:    ldxr    %w0, %2\n"
 "    add    %w0, %w0, %w3\n"
@@ -62,6 +63,7 @@ static inline int atomic_add_return(int i, atomic_t *v)
     unsigned long tmp;
     int result;

+    prefetchw(&v->counter);
     asm volatile("// atomic_add_return\n"
 "1:    ldxr    %w0, %2\n"
 "    add    %w0, %w0, %w3\n"
@@ -80,6 +82,7 @@ static inline void atomic_sub(int i, atomic_t *v)
     unsigned long tmp;
     int result;

+    prefetchw(&v->counter);
     asm volatile("// atomic_sub\n"
 "1:    ldxr    %w0, %2\n"
 "    sub    %w0, %w0, %w3\n"
@@ -94,6 +97,7 @@ static inline int atomic_sub_return(int i, atomic_t *v)
     unsigned long tmp;
     int result;

+    prefetchw(&v->counter);
     asm volatile("// atomic_sub_return\n"
 "1:    ldxr    %w0, %2\n"
 "    sub    %w0, %w0, %w3\n"
@@ -113,6 +117,7 @@ static inline int atomic_cmpxchg(atomic_t *ptr,
int old, int new)
     int oldval;

     smp_mb();
+    prefetchw(&v->counter);

     asm volatile("// atomic_cmpxchg\n"
 "1:    ldxr    %w1, %2\n"
@@ -170,6 +175,7 @@ static inline void atomic64_add(u64 i, atomic64_t *v)
     long result;
     unsigned long tmp;

+    prefetchw(&v->counter);
     asm volatile("// atomic64_add\n"
 "1:    ldxr    %0, %2\n"
 "    add    %0, %0, %3\n"
@@ -184,6 +190,7 @@ static inline long atomic64_add_return(long i,
atomic64_t *v)
     long result;
     unsigned long tmp;

+    prefetchw(&v->counter);
     asm volatile("// atomic64_add_return\n"
 "1:    ldxr    %0, %2\n"
 "    add    %0, %0, %3\n"
@@ -202,6 +209,7 @@ static inline void atomic64_sub(u64 i, atomic64_t *v)
     long result;
     unsigned long tmp;

+    prefetchw(&v->counter);
     asm volatile("// atomic64_sub\n"
 "1:    ldxr    %0, %2\n"
 "    sub    %0, %0, %3\n"
@@ -216,6 +224,7 @@ static inline long atomic64_sub_return(long i,
atomic64_t *v)
     long result;
     unsigned long tmp;

+    prefetchw(&v->counter);
     asm volatile("// atomic64_sub_return\n"
 "1:    ldxr    %0, %2\n"
 "    sub    %0, %0, %3\n"
@@ -235,6 +244,7 @@ static inline long atomic64_cmpxchg(atomic64_t
*ptr, long old, long new)
     unsigned long res;

     smp_mb();
+    prefetchw(&v->counter);

     asm volatile("// atomic64_cmpxchg\n"
 "1:    ldxr    %1, %2\n"
@@ -258,6 +268,7 @@ static inline long atomic64_dec_if_positive(atomic64_t *v)
     long result;
     unsigned long tmp;

+    prefetchw(&v->counter);
     asm volatile("// atomic64_dec_if_positive\n"
 "1:    ldxr    %0, %2\n"
 "    subs    %0, %0, #1\n"
-- 
1.9.1


-- 
Pranith
