Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaIWJZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:25:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbaIWJZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:25:53 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] mm, debug: mm-introduce-vm_bug_on_mm-fix.patch
Date: Tue, 23 Sep 2014 11:24:39 +0200
Message-Id: <1411464279-20158-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
References: <5420b8b0.9HdYLyyuTikszzH8%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump_mm wants to dump mm->owner even when CONFIG_MEMCG is not defined
which leads to a compilation error:
mm/debug.c: In function ‘dump_mm’:
mm/debug.c:212:5: error: ‘const struct mm_struct’ has no member named ‘owner’
   mm->owner, mm->exe_file,

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/debug.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/debug.c b/mm/debug.c
index 281abb2edddd..63aba9dcfb4e 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -181,7 +181,10 @@ void dump_mm(const struct mm_struct *mm)
 #ifdef CONFIG_AIO
 		"ioctx_table %p\n"
 #endif
-		"owner %p exe_file %p\n"
+#ifdef CONFIG_MEMCG
+		"owner %p "
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
2.1.0

