Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3HRUf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:35:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590Ab3HRUfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 43/45] s390: Fix broken build
Date: Sun, 18 Aug 2013 13:36:32 -0700
Message-Id: <20130818203623.985028222@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/tlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


