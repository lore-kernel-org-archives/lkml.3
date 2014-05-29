Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaE2XLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:11:06 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:42420 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaE2XLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:11:04 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: James Hogan <james.hogan@imgtec.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-metag@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: metag: mm: hugetlbpage.c:  Fix to remove null pointer checks that could never happen
Date: Fri, 30 May 2014 01:11:58 +0200
Message-Id: <1401405118-11387-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removal of null pointer checks that could never happen

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/metag/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/metag/mm/hugetlbpage.c b/arch/metag/mm/hugetlbpage.c
index 0424315..e89c843 100644
--- a/arch/metag/mm/hugetlbpage.c
+++ b/arch/metag/mm/hugetlbpage.c
@@ -178,7 +178,7 @@ new_search:
 				mm->context.part_huge = 0;
 			return addr;
 		}
-		if (vma && (vma->vm_flags & MAP_HUGETLB)) {
+		if ((vma->vm_flags & MAP_HUGETLB)) {
 			/* space after a huge vma in 2nd level page table? */
 			if (vma->vm_end & HUGEPT_MASK) {
 				after_huge = 1;
-- 
1.7.10.4

