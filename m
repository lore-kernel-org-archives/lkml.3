Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaAMO2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:28:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51490 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaAMO0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 67/96] Revert "mm: ensure get_unmapped_area() returns higher address than mmap_min_addr"
Date: Mon, 13 Jan 2014 14:24:30 +0000
Message-Id: <1389623099-18783-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques <luis.henriques@canonical.com>

This reverts commit 745545489d25d1b9ecf2d78a8f9a31a362806d2d, which is
commit 2afc745f3e3079ab16c826be4860da2529054dd2 upstream.

According to Akira, the backport for the 3.5 kernel was insufficient to
solve the problem.  Thus, this is being reverted and a complete fix will be
applied.

Cc: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/mmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 758ff55..7e24763 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1443,7 +1443,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	struct vm_area_struct *vma;
 	unsigned long start_addr;
 
-	if (len > TASK_SIZE - mmap_min_addr)
+	if (len > TASK_SIZE)
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED)
@@ -1452,7 +1452,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
+		if (TASK_SIZE - len >= addr &&
 		    (!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
@@ -1517,7 +1517,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	unsigned long addr = addr0, start_addr;
 
 	/* requested length too big for entire address space */
-	if (len > TASK_SIZE - mmap_min_addr)
+	if (len > TASK_SIZE)
 		return -ENOMEM;
 
 	if (flags & MAP_FIXED)
@@ -1527,7 +1527,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
 		vma = find_vma(mm, addr);
-		if (TASK_SIZE - len >= addr && addr >= mmap_min_addr &&
+		if (TASK_SIZE - len >= addr &&
 				(!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
-- 
1.8.3.2

