Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab3DGJd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 05:33:28 -0400
Received: from mail-pa0-f67.google.com ([209.85.220.67]:58165 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932947Ab3DGJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 05:33:27 -0400
From: k80c <k80ck80c@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        k80c <k80ck80c@gmail.com>
Subject: [PATCH 1/1] mmap.c: find_vma: eliminate initial if(mm) check
Date: Sun,  7 Apr 2013 14:48:12 +0530
Message-Id: <1365326292-2761-1-git-send-email-k80ck80c@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per commit 841e31e5cc6219d62054788faa289b6ed682d068,
we dont really need this if(mm) check anymore.

A WARN_ON_ONCE was added just for safety, but there have been no bug
reports about this so far.

Removing this if(mm) check.

Signed-off-by: k80c <k80ck80c@gmail.com>
---
 mm/mmap.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 0db0de1..b2c363f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1935,9 +1935,6 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
 	struct vm_area_struct *vma = NULL;
 
-	if (WARN_ON_ONCE(!mm))		/* Remove this in linux-3.6 */
-		return NULL;
-
 	/* Check the cache first. */
 	/* (Cache hit rate is typically around 35%.) */
 	vma = ACCESS_ONCE(mm->mmap_cache);
-- 
1.7.5.4

