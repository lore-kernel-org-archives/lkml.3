Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaHIHjW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 03:39:22 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58894 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaHIHjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 03:39:21 -0400
From: Jeremiah Mahler <jmmahler@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH v2 linux-next] arch/x86/mm: sparse 'tlb_single_page_flush_ceiling' warning
Date: Sat,  9 Aug 2014 00:38:33 -0700
Message-Id: <1407569913-4035-1-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.0.rc1
In-Reply-To: <alpine.DEB.2.02.1408081503270.15603@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1408081503270.15603@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A sparse warning is generated about 'tlb_single_page_flush_ceiling'
not being declared.

  arch/x86/mm/tlb.c:177:15: warning: symbol
  'tlb_single_page_flush_ceiling' was not declared. Should it be static?

Since it isn't used anywhere outside this file, fix the warning by
making it static.

Also, optimize the use of this variable by adding the __read_mostly
directive.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
Suggested-by: David Rientjes <rientjes@google.com>
---

Notes:
    I like the suggestion from David Rientjes, to add __read_mostly.
    Patch updated.

 arch/x86/mm/tlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 1fe3398..bbe5766 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -174,7 +174,7 @@ void flush_tlb_current_task(void)
  *
  * This is in units of pages.
  */
-unsigned long tlb_single_page_flush_ceiling = 33;
+static unsigned long tlb_single_page_flush_ceiling __read_mostly = 33;
 
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned long vmflag)
-- 
2.1.0.rc1

