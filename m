Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbaLLACb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 19:02:31 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:61626 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098AbaLLACS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:02:18 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] linux/nodemask.h: Update bitmap wrappers to take unsigned int
Date: Fri, 12 Dec 2014 01:01:48 +0100
Message-Id: <1418342514-21630-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1418342514-21630-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the various bitmap_* functions now take an unsigned int as nbits
parameter, it makes sense to also update the various wrappers.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/nodemask.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 83a6aeda899d..21cef483dc1b 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -120,13 +120,13 @@ static inline void __node_clear(int node, volatile nodemask_t *dstp)
 }
 
 #define nodes_setall(dst) __nodes_setall(&(dst), MAX_NUMNODES)
-static inline void __nodes_setall(nodemask_t *dstp, int nbits)
+static inline void __nodes_setall(nodemask_t *dstp, unsigned int nbits)
 {
 	bitmap_fill(dstp->bits, nbits);
 }
 
 #define nodes_clear(dst) __nodes_clear(&(dst), MAX_NUMNODES)
-static inline void __nodes_clear(nodemask_t *dstp, int nbits)
+static inline void __nodes_clear(nodemask_t *dstp, unsigned int nbits)
 {
 	bitmap_zero(dstp->bits, nbits);
 }
@@ -144,7 +144,7 @@ static inline int __node_test_and_set(int node, nodemask_t *addr)
 #define nodes_and(dst, src1, src2) \
 			__nodes_and(&(dst), &(src1), &(src2), MAX_NUMNODES)
 static inline void __nodes_and(nodemask_t *dstp, const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
@@ -152,7 +152,7 @@ static inline void __nodes_and(nodemask_t *dstp, const nodemask_t *src1p,
 #define nodes_or(dst, src1, src2) \
 			__nodes_or(&(dst), &(src1), &(src2), MAX_NUMNODES)
 static inline void __nodes_or(nodemask_t *dstp, const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	bitmap_or(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
@@ -160,7 +160,7 @@ static inline void __nodes_or(nodemask_t *dstp, const nodemask_t *src1p,
 #define nodes_xor(dst, src1, src2) \
 			__nodes_xor(&(dst), &(src1), &(src2), MAX_NUMNODES)
 static inline void __nodes_xor(nodemask_t *dstp, const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	bitmap_xor(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
@@ -168,7 +168,7 @@ static inline void __nodes_xor(nodemask_t *dstp, const nodemask_t *src1p,
 #define nodes_andnot(dst, src1, src2) \
 			__nodes_andnot(&(dst), &(src1), &(src2), MAX_NUMNODES)
 static inline void __nodes_andnot(nodemask_t *dstp, const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
@@ -176,7 +176,7 @@ static inline void __nodes_andnot(nodemask_t *dstp, const nodemask_t *src1p,
 #define nodes_complement(dst, src) \
 			__nodes_complement(&(dst), &(src), MAX_NUMNODES)
 static inline void __nodes_complement(nodemask_t *dstp,
-					const nodemask_t *srcp, int nbits)
+					const nodemask_t *srcp, unsigned int nbits)
 {
 	bitmap_complement(dstp->bits, srcp->bits, nbits);
 }
@@ -184,7 +184,7 @@ static inline void __nodes_complement(nodemask_t *dstp,
 #define nodes_equal(src1, src2) \
 			__nodes_equal(&(src1), &(src2), MAX_NUMNODES)
 static inline int __nodes_equal(const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_equal(src1p->bits, src2p->bits, nbits);
 }
@@ -192,7 +192,7 @@ static inline int __nodes_equal(const nodemask_t *src1p,
 #define nodes_intersects(src1, src2) \
 			__nodes_intersects(&(src1), &(src2), MAX_NUMNODES)
 static inline int __nodes_intersects(const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_intersects(src1p->bits, src2p->bits, nbits);
 }
@@ -200,25 +200,25 @@ static inline int __nodes_intersects(const nodemask_t *src1p,
 #define nodes_subset(src1, src2) \
 			__nodes_subset(&(src1), &(src2), MAX_NUMNODES)
 static inline int __nodes_subset(const nodemask_t *src1p,
-					const nodemask_t *src2p, int nbits)
+					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_subset(src1p->bits, src2p->bits, nbits);
 }
 
 #define nodes_empty(src) __nodes_empty(&(src), MAX_NUMNODES)
-static inline int __nodes_empty(const nodemask_t *srcp, int nbits)
+static inline int __nodes_empty(const nodemask_t *srcp, unsigned int nbits)
 {
 	return bitmap_empty(srcp->bits, nbits);
 }
 
 #define nodes_full(nodemask) __nodes_full(&(nodemask), MAX_NUMNODES)
-static inline int __nodes_full(const nodemask_t *srcp, int nbits)
+static inline int __nodes_full(const nodemask_t *srcp, unsigned int nbits)
 {
 	return bitmap_full(srcp->bits, nbits);
 }
 
 #define nodes_weight(nodemask) __nodes_weight(&(nodemask), MAX_NUMNODES)
-static inline int __nodes_weight(const nodemask_t *srcp, int nbits)
+static inline int __nodes_weight(const nodemask_t *srcp, unsigned int nbits)
 {
 	return bitmap_weight(srcp->bits, nbits);
 }
-- 
2.1.3

