Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaHHHZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:25:22 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36748 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaHHHZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:25:20 -0400
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH linux-next] arch/x86/mm: sparse 'tlb_single_page_flush_ceiling' warning
Date: Fri,  8 Aug 2014 00:24:31 -0700
Message-Id: <1407482671-23856-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A sparse warning is generated about 'tlb_single_page_flush_ceiling'
not being declared.

  arch/x86/mm/tlb.c:177:15: warning: symbol
  'tlb_single_page_flush_ceiling' was not declared. Should it be static?

Since it isn't used anywhere outside this file, fix the warning by
making it static.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 arch/x86/mm/tlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 1fe3398..fff4a4c 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -174,7 +174,7 @@ void flush_tlb_current_task(void)
  *
  * This is in units of pages.
  */
-unsigned long tlb_single_page_flush_ceiling = 33;
+static unsigned long tlb_single_page_flush_ceiling = 33;
 
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned long vmflag)
-- 
2.1.0.rc1

