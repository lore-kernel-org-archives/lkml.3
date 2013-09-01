Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3IAL2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 07:28:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41058 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757375Ab3IAL2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 07:28:42 -0400
Date: Sun, 1 Sep 2013 04:27:30 -0700
Message-Id: <201309011127.r81BRUpq025346@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.11-rc8
Cc: <stable@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A single very small boot fix for very large memory systems (> 0.5T).

The following changes since commit fd3930f70c8d14008f3377d51ce039806dfc542e:

  proc: more readdir conversion bug-fixes (2013-08-19 16:26:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

The head of this tree is 527bf129f9a780e11b251cf2467dc30118a57d16.

  x86/mm: Fix boot crash with DEBUG_PAGE_ALLOC=y and more than 512G RAM (2013-08-20 10:06:50 +0200)

----------------------------------------------------------------
Yinghai Lu (1):
      x86/mm: Fix boot crash with DEBUG_PAGE_ALLOC=y and more than 512G RAM

 arch/x86/mm/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 2ec29ac..04664cd 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -78,8 +78,8 @@ __ref void *alloc_low_pages(unsigned int num)
 	return __va(pfn << PAGE_SHIFT);
 }
 
-/* need 4 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
-#define INIT_PGT_BUF_SIZE	(5 * PAGE_SIZE)
+/* need 3 4k for initial PMD_SIZE,  3 4k for 0-ISA_END_ADDRESS */
+#define INIT_PGT_BUF_SIZE	(6 * PAGE_SIZE)
 RESERVE_BRK(early_pgt_alloc, INIT_PGT_BUF_SIZE);
 void  __init early_alloc_pgt_buf(void)
 {
