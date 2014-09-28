Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaI1V4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 17:56:36 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37859 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaI1V4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 17:56:35 -0400
Date: Sun, 28 Sep 2014 16:54:26 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fixed Conditional white space problems
Message-ID: <20140928215426.GA10384@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My first patch, resent to appropriate multiple addresses!

This patch fixes the following checkpatch.pl Warnings:

WARNING: suspect code indent for conditional statements (16, 16)
+               for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
[...]
+               {

WARNING: suspect code indent for conditional statements (16, 16)
+               for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
[...]
+               {

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/skein_block.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
index 616364f..bbb5a5b 100644
--- a/drivers/staging/skein/skein_block.c
+++ b/drivers/staging/skein/skein_block.c
@@ -380,7 +380,7 @@ do { \
 
 		for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
 #endif /* end of looped code definitions */
-		{
+			{
 #define R512_8_ROUNDS(R)  /* do 8 full rounds */  \
 do { \
 		R512(0, 1, 2, 3, 4, 5, 6, 7, R_512_0, 8 * (R) + 1);   \
@@ -447,7 +447,7 @@ do { \
 	#if  (SKEIN_UNROLL_512 > 14)
 #error  "need more unrolling in skein_512_process_block"
 	#endif
-		}
+			}
 
 		/* do the final "feedforward" xor, update context chaining */
 		ctx->x[0] = X0 ^ w[0];
@@ -659,7 +659,7 @@ do { \
 
 		for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
 #endif
-		{
+			{
 #define R1024_8_ROUNDS(R) \
 do { \
 	R1024(00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, \
@@ -734,7 +734,7 @@ do { \
 #if  (SKEIN_UNROLL_1024 > 14)
 #error  "need more unrolling in Skein_1024_Process_Block"
   #endif
-		}
+			}
 		/* do the final "feedforward" xor, update context chaining */
 
 		ctx->x[0] = X00 ^ w[0];
-- 
1.7.10.4

