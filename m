Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab3ICQ2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:28:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46612 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab3ICQ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:28:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 27/58] s390: Fix broken build
Date: Tue,  3 Sep 2013 09:23:31 -0700
Message-Id: <1378225442-20654-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 215b28a5308f3d332df2ee09ef11fda45d7e4a92 upstream.

Fix this build error:

  In file included from fs/exec.c:61:0:
  arch/s390/include/asm/tlb.h:35:23: error: expected identifier or '(' before 'unsigned'
  arch/s390/include/asm/tlb.h:36:1: warning: no semicolon at end of struct or union [enabled by default]
  arch/s390/include/asm/tlb.h: In function 'tlb_gather_mmu':
  arch/s390/include/asm/tlb.h:57:5: error: 'struct mmu_gather' has no member named 'end'

Broken due to commit 2b047252d0 ("Fix TLB gather virtual address range
invalidation corner cases").

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ Oh well. We had build testing for ppc amd um, but no s390  - Linus ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/include/asm/tlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index 23a64d2..6d6d92b 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -32,7 +32,7 @@ struct mmu_gather {
 	struct mm_struct *mm;
 	struct mmu_table_batch *batch;
 	unsigned int fullmm;
-	unsigned long start, unsigned long end;
+	unsigned long start, end;
 };
 
 struct mmu_table_batch {
-- 
1.8.1.2

