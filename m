Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaLYSPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 13:15:40 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49966 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbaLYSPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 13:15:38 -0500
From: Arno Tiemersma <arno.tiemersma@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arno Tiemersma <arno.tiemersma@gmail.com>
Subject: [PATCH v2] staging: skein: Fix checkpatch warnings
Date: Thu, 25 Dec 2014 19:15:30 +0100
Message-Id: <1419531330-17869-1-git-send-email-arno.tiemersma@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419530782.6157.15.camel@perches.com>
References: <1419530782.6157.15.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove do {} while (0) loops around single statements in
skein/skein_block.c

Signed-off-by: Arno Tiemersma <arno.tiemersma@gmail.com>
---
 drivers/staging/skein/skein_block.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 66261ab..39dccf8 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -83,9 +83,7 @@ do {                                                                      \
 #else
 /* looping version */
 #define R256(p0, p1, p2, p3, ROT, r_num) \
-do { \
-	ROUND256(p0, p1, p2, p3, ROT, r_num); \
-} while (0)
+	ROUND256(p0, p1, p2, p3, ROT, r_num)
 
 #define I256(R) \
 do { \
@@ -174,9 +172,7 @@ do {                                                                      \
 
 #else /* looping version */
 #define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)                 \
-do {                                                                     \
-	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num);            \
-} while (0)
+	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)
 
 #define I512(R)                                                           \
 do {                                                                      \
@@ -263,10 +259,8 @@ do {                                                                          \
 #if SKEIN_UNROLL_1024 == 0
 #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
 	      ROT, rn)                                                        \
-do {                                                                          \
 	ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
-		  pF, ROT, rn);                                               \
-} while (0)
+		  pF, ROT, rn)
 
 #define I1024(R)                                                          \
 do {                                                                      \
@@ -291,10 +285,8 @@ do {                                                                      \
 #else /* looping version */
 #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
 	      ROT, rn)                                                        \
-do {                                                                          \
 	ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
-		  pF, ROT, rn);                                               \
-} while (0)
+		  pF, ROT, rn)
 
 #define I1024(R)                                                           \
 do {                                                                       \
-- 
2.1.0

