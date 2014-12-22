Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaLVAKI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 19:10:08 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58429 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaLVAKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 19:10:06 -0500
From: mathieu.poirier@linaro.org
To: jason@lakedaemon.net, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH] staging: skein: Fixing various coding style problems
Date: Sun, 21 Dec 2014 17:09:48 -0700
Message-Id: <1419206988-27331-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Fixing errors related to the usage of do {} while (0) loop
in single statement macros, trailing semicolon in macros and
trailing whitespace.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/staging/skein/skein_block.c   | 17 ++++-------------
 drivers/staging/skein/skein_generic.c |  1 -
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 66261ab25c88..43a342372633 100644
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
+	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)
 
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
+		  pF, ROT, rn)
 
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
+		  pF, ROT, rn)
 
 #define I1024(R)                                                           \
 do {                                                                       \
diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
index 85bd7d0168b0..899078f1b8bc 100644
--- a/drivers/staging/skein/skein_generic.c
+++ b/drivers/staging/skein/skein_generic.c
@@ -191,7 +191,6 @@ static int __init skein_generic_init(void)
 
 	return 0;
 
-		
 unreg512:
 	crypto_unregister_shash(&alg512);
 unreg256:
-- 
1.9.1

