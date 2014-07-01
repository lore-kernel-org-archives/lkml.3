Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaGAAqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:46:39 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:63946 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGAAqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:46:38 -0400
Date: Mon, 30 Jun 2014 17:46:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] mm, hugetlb: remove hugetlb_zero and hugetlb_infinity
In-Reply-To: <alpine.DEB.2.02.1406301655480.27587@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1406301745200.7070@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406301655480.27587@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are unnecessary: "zero" can be used in place of "hugetlb_zero" and 
passing extra2 == NULL is equivalent to infinity.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/hugetlb.h | 1 -
 kernel/sysctl.c         | 9 +++------
 mm/hugetlb.c            | 1 -
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -86,7 +86,6 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
 #endif
 
 extern unsigned long hugepages_treat_as_movable;
-extern const unsigned long hugetlb_zero, hugetlb_infinity;
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages;
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1240,8 +1240,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= hugetlb_sysctl_handler,
-		.extra1		= (void *)&hugetlb_zero,
-		.extra2		= (void *)&hugetlb_infinity,
+		.extra1		= &zero,
 	},
 #ifdef CONFIG_NUMA
 	{
@@ -1250,8 +1249,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
 		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
-		.extra1		= (void *)&hugetlb_zero,
-		.extra2		= (void *)&hugetlb_infinity,
+		.extra1		= &zero,
 	},
 #endif
 	 {
@@ -1274,8 +1272,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= hugetlb_overcommit_handler,
-		.extra1		= (void *)&hugetlb_zero,
-		.extra2		= (void *)&hugetlb_infinity,
+		.extra1		= &zero,
 	},
 #endif
 	{
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -35,7 +35,6 @@
 #include <linux/node.h>
 #include "internal.h"
 
-const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
 unsigned long hugepages_treat_as_movable;
 
 int hugetlb_max_hstate __read_mostly;
