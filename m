Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967159Ab3E2XO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:14:58 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44308 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966668Ab3E2XOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:14:52 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH] mm: sparse: use __aligned() instead of manual padding in mem_section
Date: Wed, 29 May 2013 16:14:39 -0700
Message-Id: <1369869279-20155-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052923-5806-0000-0000-00002168671B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of leaving a trap for the next person who comes along and wants
to add something to mem_section, add an __aligned() and remove the
manual padding added for MEMCG.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/mmzone.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

---

Also, does anyone know what causes this alignment to be required here? I found
this was breaking things in a patchset I'm working on (WARNs in sysfs code
about duplicate filenames when initing mem_sections). Adding some documentation
for the reason would be appreciated.

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 131989a..a8e8056 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1125,9 +1125,8 @@ struct mem_section {
 	 * section. (see memcontrol.h/page_cgroup.h about this.)
 	 */
 	struct page_cgroup *page_cgroup;
-	unsigned long pad;
 #endif
-};
+} __aligned(2 * sizeof(unsigned long));
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
 #define SECTIONS_PER_ROOT       (PAGE_SIZE / sizeof (struct mem_section))
-- 
1.8.3

