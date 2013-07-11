Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3GKHAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 03:00:54 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53674 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab3GKHAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 03:00:53 -0400
From: Vladimir Cernov <gg.kaspersky@gmail.com>
To: akpm@linux-foundation.org
Cc: sasha.levin@oracle.com, linux@rasmusvillemoes.dk, shli@fusionio.com,
        khlebnikov@openvz.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vladimir Cernov <gg.kaspersky@gmail.com>
Subject: [PATCH] madvise: fix checkpatch errors
Date: Thu, 11 Jul 2013 10:00:37 +0300
Message-Id: <1373526037-9134-1-git-send-email-gg.kaspersky@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes following errors:
	- ERROR: "(foo*)" should be "(foo *)"
	- ERROR: "foo ** bar" should be "foo **bar"

Signed-off-by: Vladimir Cernov <gg.kaspersky@gmail.com>
---
 mm/madvise.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 7055883..936799f 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -42,11 +42,11 @@ static int madvise_need_mmap_write(int behavior)
  * We can potentially split a vm area into separate
  * areas, each area with its own behavior.
  */
-static long madvise_behavior(struct vm_area_struct * vma,
+static long madvise_behavior(struct vm_area_struct *vma,
 		     struct vm_area_struct **prev,
 		     unsigned long start, unsigned long end, int behavior)
 {
-	struct mm_struct * mm = vma->vm_mm;
+	struct mm_struct *mm = vma->vm_mm;
 	int error = 0;
 	pgoff_t pgoff;
 	unsigned long new_flags = vma->vm_flags;
@@ -215,8 +215,8 @@ static void force_shm_swapin_readahead(struct vm_area_struct *vma,
 /*
  * Schedule all required I/O operations.  Do not wait for completion.
  */
-static long madvise_willneed(struct vm_area_struct * vma,
-			     struct vm_area_struct ** prev,
+static long madvise_willneed(struct vm_area_struct *vma,
+			     struct vm_area_struct **prev,
 			     unsigned long start, unsigned long end)
 {
 	struct file *file = vma->vm_file;
@@ -270,8 +270,8 @@ static long madvise_willneed(struct vm_area_struct * vma,
  * An interface that causes the system to free clean pages and flush
  * dirty pages is already available as msync(MS_INVALIDATE).
  */
-static long madvise_dontneed(struct vm_area_struct * vma,
-			     struct vm_area_struct ** prev,
+static long madvise_dontneed(struct vm_area_struct *vma,
+			     struct vm_area_struct **prev,
 			     unsigned long start, unsigned long end)
 {
 	*prev = vma;
@@ -459,7 +459,7 @@ madvise_behavior_valid(int behavior)
 SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 {
 	unsigned long end, tmp;
-	struct vm_area_struct * vma, *prev;
+	struct vm_area_struct *vma, *prev;
 	int unmapped_error = 0;
 	int error = -EINVAL;
 	int write;
-- 
1.7.10.4

