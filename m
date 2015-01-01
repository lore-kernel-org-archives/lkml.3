Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbbAATPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 14:15:24 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:57584 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbbAATPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 14:15:23 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ralf Baechle <ralf@linux-mips.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        John Crispin <blogic@openwrt.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: mips: mm: page:  Remove unused function
Date: Thu,  1 Jan 2015 20:18:22 +0100
Message-Id: <1420139902-3776-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function sb1_dma_init() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/mips/mm/page.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/mips/mm/page.c b/arch/mips/mm/page.c
index b611102..aa43df2 100644
--- a/arch/mips/mm/page.c
+++ b/arch/mips/mm/page.c
@@ -592,21 +592,6 @@ struct dmadscr {
 	u64 pad_b;
 } ____cacheline_aligned_in_smp page_descr[DM_NUM_CHANNELS];
 
-void sb1_dma_init(void)
-{
-	int i;
-
-	for (i = 0; i < DM_NUM_CHANNELS; i++) {
-		const u64 base_val = CPHYSADDR((unsigned long)&page_descr[i]) |
-				     V_DM_DSCR_BASE_RINGSZ(1);
-		void *base_reg = IOADDR(A_DM_REGISTER(i, R_DM_DSCR_BASE));
-
-		__raw_writeq(base_val, base_reg);
-		__raw_writeq(base_val | M_DM_DSCR_BASE_RESET, base_reg);
-		__raw_writeq(base_val | M_DM_DSCR_BASE_ENABL, base_reg);
-	}
-}
-
 void clear_page(void *page)
 {
 	u64 to_phys = CPHYSADDR((unsigned long)page);
-- 
1.7.10.4

