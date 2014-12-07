Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaLGSIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 13:08:14 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:59211 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaLGSIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 13:08:09 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        "jmarchan@redhat.com" <jmarchan@redhat.com>,
        Ian Munsie <imunsie@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: mm: slice.c:  Remove unused function
Date: Sun,  7 Dec 2014 19:10:46 +0100
Message-Id: <1417975847-14153-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function slice_set_psize() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/mm/slice.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/arch/powerpc/mm/slice.c b/arch/powerpc/mm/slice.c
index ded0ea1..0f432a7 100644
--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -645,35 +645,6 @@ void slice_set_user_psize(struct mm_struct *mm, unsigned int psize)
 	spin_unlock_irqrestore(&slice_convert_lock, flags);
 }
 
-void slice_set_psize(struct mm_struct *mm, unsigned long address,
-		     unsigned int psize)
-{
-	unsigned char *hpsizes;
-	unsigned long i, flags;
-	u64 *lpsizes;
-
-	spin_lock_irqsave(&slice_convert_lock, flags);
-	if (address < SLICE_LOW_TOP) {
-		i = GET_LOW_SLICE_INDEX(address);
-		lpsizes = &mm->context.low_slices_psize;
-		*lpsizes = (*lpsizes & ~(0xful << (i * 4))) |
-			((unsigned long) psize << (i * 4));
-	} else {
-		int index, mask_index;
-		i = GET_HIGH_SLICE_INDEX(address);
-		hpsizes = mm->context.high_slices_psize;
-		mask_index = i & 0x1;
-		index = i >> 1;
-		hpsizes[index] = (hpsizes[index] &
-				  ~(0xf << (mask_index * 4))) |
-			(((unsigned long)psize) << (mask_index * 4));
-	}
-
-	spin_unlock_irqrestore(&slice_convert_lock, flags);
-
-	copro_flush_all_slbs(mm);
-}
-
 void slice_set_range_psize(struct mm_struct *mm, unsigned long start,
 			   unsigned long len, unsigned int psize)
 {
-- 
1.7.10.4

