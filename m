Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaKFFmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:42:02 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43943 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaKFFmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:42:01 -0500
From: Minfei Huang <mnfhuang@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Minfei Huang <mnfhuang@gmail.com>
Subject: [PATCH] x86/mm: Give the correct initail value to the pmd_idx
Date: Thu,  6 Nov 2014 13:41:53 +0800
Message-Id: <1415252513-6453-1-git-send-email-mnfhuang@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable value is undefined from the stack eara. So it makes sense to
init the variable to run process correctly.

If the variable pmd_idx inits the value more than PTRS_PER_PMD, the
count may be smaller than the correct value, and the allocated page may
be not enough for pte entry.

The kernel may panic cause by the undefine variable which is allocated
from stack.

Signed-off-by: Minfei Huang <mnfhuang@gmail.com>
---
 arch/x86/mm/init_32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c8140e1..c23ab1e 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -137,6 +137,7 @@ page_table_range_init_count(unsigned long start, unsigned long end)
 
 	vaddr = start;
 	pgd_idx = pgd_index(vaddr);
+	pmd_idx = pmd_index(vaddr);
 
 	for ( ; (pgd_idx < PTRS_PER_PGD) && (vaddr != end); pgd_idx++) {
 		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end);
-- 
1.8.3.1

