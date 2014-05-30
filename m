Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194AbaE3Rf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:35:28 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:60026 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaE3Rf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:35:27 -0400
From: T Makphaibulchoke <tmac@hp.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu
Cc: T Makphaibulchoke <tmac@hp.com>
Subject: [PATCH] fs/mbcache.c: replacing __builtin_log2() with ilog2()
Date: Fri, 30 May 2014 11:35:04 -0600
Message-Id: <1401471304-37479-1-git-send-email-tmac@hp.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing compiler error with some gcc version(s) that do not
support __builtin_log2().  Replacing __builtin_log2() with
ilog2().

Signed-off-by: T. Makphaibulchoke <tmac@hp.com>
---
 fs/mbcache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index bf166e3..187477d 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -73,6 +73,7 @@
 #include <linux/mbcache.h>
 #include <linux/init.h>
 #include <linux/blockgroup_lock.h>
+#include <linux/log2.h>
 
 #ifdef MB_CACHE_DEBUG
 # define mb_debug(f...) do { \
@@ -93,7 +94,7 @@
 
 #define MB_CACHE_WRITER ((unsigned short)~0U >> 1)
 
-#define MB_CACHE_ENTRY_LOCK_BITS	__builtin_log2(NR_BG_LOCKS)
+#define MB_CACHE_ENTRY_LOCK_BITS	ilog2(NR_BG_LOCKS)
 #define	MB_CACHE_ENTRY_LOCK_INDEX(ce)			\
 	(hash_long((unsigned long)ce, MB_CACHE_ENTRY_LOCK_BITS))
 
-- 
1.7.11.3

