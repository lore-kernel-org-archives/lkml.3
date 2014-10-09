Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbaJIW3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 18:29:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:55135 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980AbaJIW3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 18:29:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,688,1406617200"; 
   d="scan'208";a="603055067"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Make initrd compression algorithm selection not expert
Date: Thu,  9 Oct 2014 15:29:07 -0700
Message-Id: <1412893747-14542-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The kernel has support for (nearly) every compression algorithm known to man,
each to handle some particular microscopic niche.

Unfortunately all of these always get compiled in if you want to support INITRDs,
and can be only disabled when CONFIG_EXPERT is set.

I don't see why I need to set EXPERT just to properly configure the
initrd compression algorithms, and not always include every possible algorithm

Usually the initrd is just compressed with gzip anyways, at least that's
true on all distributions I use.

Remove the dependencies for initrd compression on CONFIG_EXPERT.

Make the various options just default y, which should be good
enough to not break any previous configuration.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 usr/Kconfig | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/usr/Kconfig b/usr/Kconfig
index 2d4c77e..572dcf7 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -46,17 +46,17 @@ config INITRAMFS_ROOT_GID
 	  If you are not sure, leave it set to "0".
 
 config RD_GZIP
-	bool "Support initial ramdisks compressed using gzip" if EXPERT
-	default y
+	bool "Support initial ramdisks compressed using gzip"
 	depends on BLK_DEV_INITRD
+	default y
 	select DECOMPRESS_GZIP
 	help
 	  Support loading of a gzip encoded initial ramdisk or cpio buffer.
 	  If unsure, say Y.
 
 config RD_BZIP2
-	bool "Support initial ramdisks compressed using bzip2" if EXPERT
-	default !EXPERT
+	bool "Support initial ramdisks compressed using bzip2"
+	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_BZIP2
 	help
@@ -64,8 +64,8 @@ config RD_BZIP2
 	  If unsure, say N.
 
 config RD_LZMA
-	bool "Support initial ramdisks compressed using LZMA" if EXPERT
-	default !EXPERT
+	bool "Support initial ramdisks compressed using LZMA"
+	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZMA
 	help
@@ -73,17 +73,17 @@ config RD_LZMA
 	  If unsure, say N.
 
 config RD_XZ
-	bool "Support initial ramdisks compressed using XZ" if EXPERT
-	default !EXPERT
+	bool "Support initial ramdisks compressed using XZ"
 	depends on BLK_DEV_INITRD
+	default y
 	select DECOMPRESS_XZ
 	help
 	  Support loading of a XZ encoded initial ramdisk or cpio buffer.
 	  If unsure, say N.
 
 config RD_LZO
-	bool "Support initial ramdisks compressed using LZO" if EXPERT
-	default !EXPERT
+	bool "Support initial ramdisks compressed using LZO"
+	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZO
 	help
@@ -91,8 +91,8 @@ config RD_LZO
 	  If unsure, say N.
 
 config RD_LZ4
-	bool "Support initial ramdisks compressed using LZ4" if EXPERT
-	default !EXPERT
+	bool "Support initial ramdisks compressed using LZ4"
+	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZ4
 	help
-- 
1.9.3

