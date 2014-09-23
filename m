Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbaIWBoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 21:44:05 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29715 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaIWBoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 21:44:03 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linuxfoundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mm: fix build breakage in dump_mm if CONFIG_MEMCG is not set
Date: Mon, 22 Sep 2014 21:43:49 -0400
Message-Id: <1411436629-12764-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm_struct->owner is only available if CONFIG_MEMCG is set, fix build
by taking that into account.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/debug.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/debug.c b/mm/debug.c
index 281abb2..544d8f6 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -181,7 +181,10 @@ void dump_mm(const struct mm_struct *mm)
 #ifdef CONFIG_AIO
 		"ioctx_table %p\n"
 #endif
-		"owner %p exe_file %p\n"
+#ifdef CONFIG_MEMCG
+		"owner %p\n"
+#endif
+		"exe_file %p\n"
 #ifdef CONFIG_MMU_NOTIFIER
 		"mmu_notifier_mm %p\n"
 #endif
@@ -209,7 +212,10 @@ void dump_mm(const struct mm_struct *mm)
 #ifdef CONFIG_AIO
 		mm->ioctx_table,
 #endif
-		mm->owner, mm->exe_file,
+#ifdef CONFIG_MEMCG
+		mm->owner,
+#endif
+		mm->exe_file,
 #ifdef CONFIG_MMU_NOTIFIER
 		mm->mmu_notifier_mm,
 #endif
-- 
1.7.10.4

