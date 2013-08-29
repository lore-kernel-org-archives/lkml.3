Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3H2BUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:20:07 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:65261 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3H2BUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:20:05 -0400
From: Yanchuan Nian <ycnian@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Yanchuan Nian <ycnian@gmail.com>
Subject: [PATCH] mm/mmap: remove unnecessary assignment
Date: Thu, 29 Aug 2013 09:23:44 +0800
Message-Id: <1377739424-21293-1-git-send-email-ycnian@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yanchuan Nian <ycnian@gmail.com>

pgoff is not used after the statement "pgoff = vma->vm_pgoff;",
so the assignment is redundant.

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
---
 mm/mmap.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 2664a47..e7d7231 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1508,7 +1508,6 @@ munmap_back:
 		WARN_ON_ONCE(addr != vma->vm_start);
 
 		addr = vma->vm_start;
-		pgoff = vma->vm_pgoff;
 		vm_flags = vma->vm_flags;
 	} else if (vm_flags & VM_SHARED) {
 		if (unlikely(vm_flags & (VM_GROWSDOWN|VM_GROWSUP)))
-- 
1.7.4.4

