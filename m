Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbaLVPVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:21:05 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59479 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaLVPVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:21:02 -0500
From: mathieu.poirier@linaro.org
To: jason@lakedaemon.net, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH v2 2/2] staging: skein: Fixing single statement macro checkpatch warning
Date: Mon, 22 Dec 2014 08:20:39 -0700
Message-Id: <1419261639-17157-3-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419261639-17157-1-git-send-email-mathieu.poirier@linaro.org>
References: <1419261639-17157-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

WARNING: Single statement macros should not use a do {} while (0) loop

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/staging/skein/skein_block.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 66261ab25c88..9bd69ce3be00 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -82,10 +82,7 @@ do {                                                                      \
 } while (0)
 #else
 /* looping version */
-#define R256(p0, p1, p2, p3, ROT, r_num) \
-do { \
-	ROUND256(p0, p1, p2, p3, ROT, r_num); \
-} while (0)
+#define R256(p0, p1, p2, p3, ROT, r_num) ROUND256(p0, p1, p2, p3, ROT, r_num)
 
 #define I256(R) \
 do { \
@@ -174,9 +171,7 @@ do {                                                                      \
 
 #else /* looping version */
 #define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)                 \
-do {                                                                     \
-	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num);            \
-} while (0)
+	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)             \
 
 #define I512(R)                                                           \
 do {                                                                      \
@@ -263,10 +258,8 @@ do {                                                                          \
 #if SKEIN_UNROLL_1024 == 0
 #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
 	      ROT, rn)                                                        \
-do {                                                                          \
 	ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
-		  pF, ROT, rn);                                               \
-} while (0)
+		  pF, ROT, rn)                                                \
 
 #define I1024(R)                                                          \
 do {                                                                      \
@@ -291,10 +284,8 @@ do {                                                                      \
 #else /* looping version */
 #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
 	      ROT, rn)                                                        \
-do {                                                                          \
 	ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
-		  pF, ROT, rn);                                               \
-} while (0)
+		  pF, ROT, rn)                                                \
 
 #define I1024(R)                                                           \
 do {                                                                       \
-- 
1.9.1

