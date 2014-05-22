Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaEVWAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:00:54 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62264 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaEVWAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:00:52 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: James Hogan <james.hogan@imgtec.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-metag@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: metag: mm: hugetlbpage.c:  Cleaning up inconsistent NULL checks
Date: Fri, 23 May 2014 00:01:42 +0200
Message-Id: <1400796102-12832-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning up inconsistent NULL checks.
There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/metag/mm/hugetlbpage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/metag/mm/hugetlbpage.c b/arch/metag/mm/hugetlbpage.c
index 0424315..3f8d5cd 100644
--- a/arch/metag/mm/hugetlbpage.c
+++ b/arch/metag/mm/hugetlbpage.c
@@ -188,7 +188,8 @@ new_search:
 			}
 		}
 		after_huge = 0;
-		addr = ALIGN_HUGEPT(vma->vm_end);
+		if (vma)
+			addr = ALIGN_HUGEPT(vma->vm_end);
 	}
 }
 #endif
-- 
1.7.10.4

