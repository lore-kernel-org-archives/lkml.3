Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab3HQDvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 23:51:09 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:47443 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab3HQDvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 23:51:06 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH] s390: Fix broken build
Date: Fri, 16 Aug 2013 20:50:55 -0700
Message-Id: <1376711455-31441-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:

In file included from fs/exec.c:61:0:
arch/s390/include/asm/tlb.h:35:23: error: expected identifier or '(' before 'unsigned'
arch/s390/include/asm/tlb.h:36:1: warning: no semicolon at end of struct or union [enabled by default]
arch/s390/include/asm/tlb.h: In function 'tlb_gather_mmu':
arch/s390/include/asm/tlb.h:57:5: error: 'struct mmu_gather' has no member named 'end'
make[1]: *** [fs/exec.o] Error 1

Broken due to commit 2b047252d0 (Fix TLB gather virtual address range
invalidation corner cases).

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/s390/include/asm/tlb.h |    2 +-
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
1.7.9.7

