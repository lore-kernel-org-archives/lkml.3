Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaFBAIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 20:08:00 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47323 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaFBAH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 20:07:59 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH] staging: skein: fix sparse warning for static arrays
Date: Sun,  1 Jun 2014 20:07:35 -0400
Message-Id: <1401667656-17926-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:

skein_iv.h:23:11: warning: symbol 'SKEIN_256_IV_128' was not declared. Should it be static?
skein_iv.h:31:11: warning: symbol 'SKEIN_256_IV_160' was not declared. Should it be static?
skein_iv.h:39:11: warning: symbol 'SKEIN_256_IV_224' was not declared. Should it be static?
skein_iv.h:47:11: warning: symbol 'SKEIN_256_IV_256' was not declared. Should it be static?
skein_iv.h:55:11: warning: symbol 'SKEIN_512_IV_128' was not declared. Should it be static?
skein_iv.h:67:11: warning: symbol 'SKEIN_512_IV_160' was not declared. Should it be static?
skein_iv.h:79:11: warning: symbol 'SKEIN_512_IV_224' was not declared. Should it be static?
skein_iv.h:91:11: warning: symbol 'SKEIN_512_IV_256' was not declared. Should it be static?
skein_iv.h:103:11: warning: symbol 'SKEIN_512_IV_384' was not declared. Should it be static?
skein_iv.h:115:11: warning: symbol 'SKEIN_512_IV_512' was not declared. Should it be static?
skein_iv.h:127:11: warning: symbol 'SKEIN_1024_IV_384' was not declared. Should it be static?
skein_iv.h:147:11: warning: symbol 'SKEIN_1024_IV_512' was not declared. Should it be static?
skein_iv.h:167:11: warning: symbol 'SKEIN_1024_IV_1024' was not declared. Should it be static?

by declaring the initialization vectors in question as static.  The header
skein_iv.h is only included by skein.c

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/skein/skein_iv.h |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/skein/skein_iv.h b/drivers/staging/skein/skein_iv.h
index a03703d..d9dc1d5 100644
--- a/drivers/staging/skein/skein_iv.h
+++ b/drivers/staging/skein/skein_iv.h
@@ -20,7 +20,7 @@
 #define MK_64 SKEIN_MK_64
 
 /* blkSize =  256 bits. hashSize =  128 bits */
-const u64 SKEIN_256_IV_128[] = {
+static const u64 SKEIN_256_IV_128[] = {
 	MK_64(0xE1111906, 0x964D7260),
 	MK_64(0x883DAAA7, 0x7C8D811C),
 	MK_64(0x10080DF4, 0x91960F7A),
@@ -28,7 +28,7 @@ const u64 SKEIN_256_IV_128[] = {
 };
 
 /* blkSize =  256 bits. hashSize =  160 bits */
-const u64 SKEIN_256_IV_160[] = {
+static const u64 SKEIN_256_IV_160[] = {
 	MK_64(0x14202314, 0x72825E98),
 	MK_64(0x2AC4E9A2, 0x5A77E590),
 	MK_64(0xD47A5856, 0x8838D63E),
@@ -36,7 +36,7 @@ const u64 SKEIN_256_IV_160[] = {
 };
 
 /* blkSize =  256 bits. hashSize =  224 bits */
-const u64 SKEIN_256_IV_224[] = {
+static const u64 SKEIN_256_IV_224[] = {
 	MK_64(0xC6098A8C, 0x9AE5EA0B),
 	MK_64(0x876D5686, 0x08C5191C),
 	MK_64(0x99CB88D7, 0xD7F53884),
@@ -44,7 +44,7 @@ const u64 SKEIN_256_IV_224[] = {
 };
 
 /* blkSize =  256 bits. hashSize =  256 bits */
-const u64 SKEIN_256_IV_256[] = {
+static const u64 SKEIN_256_IV_256[] = {
 	MK_64(0xFC9DA860, 0xD048B449),
 	MK_64(0x2FCA6647, 0x9FA7D833),
 	MK_64(0xB33BC389, 0x6656840F),
@@ -52,7 +52,7 @@ const u64 SKEIN_256_IV_256[] = {
 };
 
 /* blkSize =  512 bits. hashSize =  128 bits */
-const u64 SKEIN_512_IV_128[] = {
+static const u64 SKEIN_512_IV_128[] = {
 	MK_64(0xA8BC7BF3, 0x6FBF9F52),
 	MK_64(0x1E9872CE, 0xBD1AF0AA),
 	MK_64(0x309B1790, 0xB32190D3),
@@ -64,7 +64,7 @@ const u64 SKEIN_512_IV_128[] = {
 };
 
 /* blkSize =  512 bits. hashSize =  160 bits */
-const u64 SKEIN_512_IV_160[] = {
+static const u64 SKEIN_512_IV_160[] = {
 	MK_64(0x28B81A2A, 0xE013BD91),
 	MK_64(0xC2F11668, 0xB5BDF78F),
 	MK_64(0x1760D8F3, 0xF6A56F12),
@@ -76,7 +76,7 @@ const u64 SKEIN_512_IV_160[] = {
 };
 
 /* blkSize =  512 bits. hashSize =  224 bits */
-const u64 SKEIN_512_IV_224[] = {
+static const u64 SKEIN_512_IV_224[] = {
 	MK_64(0xCCD06162, 0x48677224),
 	MK_64(0xCBA65CF3, 0xA92339EF),
 	MK_64(0x8CCD69D6, 0x52FF4B64),
@@ -88,7 +88,7 @@ const u64 SKEIN_512_IV_224[] = {
 };
 
 /* blkSize =  512 bits. hashSize =  256 bits */
-const u64 SKEIN_512_IV_256[] = {
+static const u64 SKEIN_512_IV_256[] = {
 	MK_64(0xCCD044A1, 0x2FDB3E13),
 	MK_64(0xE8359030, 0x1A79A9EB),
 	MK_64(0x55AEA061, 0x4F816E6F),
@@ -100,7 +100,7 @@ const u64 SKEIN_512_IV_256[] = {
 };
 
 /* blkSize =  512 bits. hashSize =  384 bits */
-const u64 SKEIN_512_IV_384[] = {
+static const u64 SKEIN_512_IV_384[] = {
 	MK_64(0xA3F6C6BF, 0x3A75EF5F),
 	MK_64(0xB0FEF9CC, 0xFD84FAA4),
 	MK_64(0x9D77DD66, 0x3D770CFE),
@@ -112,7 +112,7 @@ const u64 SKEIN_512_IV_384[] = {
 };
 
 /* blkSize =  512 bits. hashSize =  512 bits */
-const u64 SKEIN_512_IV_512[] = {
+static const u64 SKEIN_512_IV_512[] = {
 	MK_64(0x4903ADFF, 0x749C51CE),
 	MK_64(0x0D95DE39, 0x9746DF03),
 	MK_64(0x8FD19341, 0x27C79BCE),
@@ -124,7 +124,7 @@ const u64 SKEIN_512_IV_512[] = {
 };
 
 /* blkSize = 1024 bits. hashSize =  384 bits */
-const u64 SKEIN_1024_IV_384[] = {
+static const u64 SKEIN_1024_IV_384[] = {
 	MK_64(0x5102B6B8, 0xC1894A35),
 	MK_64(0xFEEBC9E3, 0xFE8AF11A),
 	MK_64(0x0C807F06, 0xE32BED71),
@@ -144,7 +144,7 @@ const u64 SKEIN_1024_IV_384[] = {
 };
 
 /* blkSize = 1024 bits. hashSize =  512 bits */
-const u64 SKEIN_1024_IV_512[] = {
+static const u64 SKEIN_1024_IV_512[] = {
 	MK_64(0xCAEC0E5D, 0x7C1B1B18),
 	MK_64(0xA01B0E04, 0x5F03E802),
 	MK_64(0x33840451, 0xED912885),
@@ -164,7 +164,7 @@ const u64 SKEIN_1024_IV_512[] = {
 };
 
 /* blkSize = 1024 bits. hashSize = 1024 bits */
-const u64 SKEIN_1024_IV_1024[] = {
+static const u64 SKEIN_1024_IV_1024[] = {
 	MK_64(0xD593DA07, 0x41E72355),
 	MK_64(0x15B5E511, 0xAC73E00C),
 	MK_64(0x5180E5AE, 0xBAF2C4F0),
-- 
1.7.9.5

