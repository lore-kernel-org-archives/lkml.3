Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaBPQnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 11:43:20 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:47205 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaBPQnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 11:43:17 -0500
Date: Mon, 17 Feb 2014 00:42:05 +0800
From: Wang YanQing <udknight@gmail.com>
To: catalin.marinas@arm.com
Cc: rob@landley.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: update kmemleak.txt
Message-ID: <20140216164205.GA5941@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	catalin.marinas@arm.com, rob@landley.net, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update Documentatin/kmemleak.txt to
reflect the following changes:

Commit b69ec42b1b194cc88f04b3fbcda8d3f93182d6c3
("Kconfig: clean up the long arch list for the DEBUG_KMEMLEAK config option")
make we can't check supported architectures by read Kconfig.debug.

Commit 85d3a316c714197f94e75c1e5b2d37607d66e5de
("kmemleak: use rbtree instead of prio tree")
convert kmemleak to use rbtree instead of prio tree.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 Documentation/kmemleak.txt | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index b6e3973..6dc8013 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -11,9 +11,7 @@ with the difference that the orphan objects are not freed but only
 reported via /sys/kernel/debug/kmemleak. A similar method is used by the
 Valgrind tool (memcheck --leak-check) to detect the memory leaks in
 user-space applications.
-
-Please check DEBUG_KMEMLEAK dependencies in lib/Kconfig.debug for supported
-architectures.
+Kmemleak is supported on x86, arm, powerpc, sparc, sh, microblaze, ppc, mips, s390, metag and tile.
 
 Usage
 -----
@@ -68,7 +66,7 @@ Basic Algorithm
 
 The memory allocations via kmalloc, vmalloc, kmem_cache_alloc and
 friends are traced and the pointers, together with additional
-information like size and stack trace, are stored in a prio search tree.
+information like size and stack trace, are stored in a rbtree.
 The corresponding freeing function calls are tracked and the pointers
 removed from the kmemleak data structures.
 
@@ -84,7 +82,7 @@ The scanning algorithm steps:
   1. mark all objects as white (remaining white objects will later be
      considered orphan)
   2. scan the memory starting with the data section and stacks, checking
-     the values against the addresses stored in the prio search tree. If
+     the values against the addresses stored in the rbtree. If
      a pointer to a white object is found, the object is added to the
      gray list
   3. scan the gray objects for matching addresses (some white objects
-- 
1.8.3.4.8.g69490f3.dirty
