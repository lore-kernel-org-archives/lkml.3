Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbaGDVIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 17:08:09 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:49258 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbaGDVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 17:08:07 -0400
Message-ID: <1404508083.2457.15.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] mm,vmacache: inline vmacache_valid_mm()
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davidlohr@hp.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 04 Jul 2014 14:08:03 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

No brainer for this little function.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 mm/vmacache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmacache.c b/mm/vmacache.c
index 9f25af8..e72b8ee 100644
--- a/mm/vmacache.c
+++ b/mm/vmacache.c
@@ -50,7 +50,7 @@ void vmacache_flush_all(struct mm_struct *mm)
  * Also handle the case where a kernel thread has adopted this mm via use_mm().
  * That kernel thread's vmacache is not applicable to this mm.
  */
-static bool vmacache_valid_mm(struct mm_struct *mm)
+static inline bool vmacache_valid_mm(struct mm_struct *mm)
 {
 	return current->mm == mm && !(current->flags & PF_KTHREAD);
 }
-- 
1.8.1.4



