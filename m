Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaHJHrI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 03:47:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38059 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaHJHrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 03:47:06 -0400
Date: Sun, 10 Aug 2014 00:46:23 -0700
From: tip-bot for Jeremiah Mahler <tipbot@zytor.com>
Message-ID: <tip-86426851c38d3fe84dee34d7daa71d26c174d409@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jmmahler@gmail.com, riel@redhat.com, mgorman@suse.de,
        tglx@linutronix.de, dave.hansen@linux.intel.com, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jmmahler@gmail.com, riel@redhat.com, mgorman@suse.de,
        tglx@linutronix.de, dave.hansen@linux.intel.com, rientjes@google.com
In-Reply-To: <1407569913-4035-1-git-send-email-jmmahler@gmail.com>
References: <1407569913-4035-1-git-send-email-jmmahler@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm: Fix sparse '
 tlb_single_page_flush_ceiling' warning and make the variable read-mostly
Git-Commit-ID: 86426851c38d3fe84dee34d7daa71d26c174d409
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86426851c38d3fe84dee34d7daa71d26c174d409
Gitweb:     http://git.kernel.org/tip/86426851c38d3fe84dee34d7daa71d26c174d409
Author:     Jeremiah Mahler <jmmahler@gmail.com>
AuthorDate: Sat, 9 Aug 2014 00:38:33 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 10 Aug 2014 09:07:18 +0200

x86/mm: Fix sparse 'tlb_single_page_flush_ceiling' warning and make the variable read-mostly

A sparse warning is generated about
'tlb_single_page_flush_ceiling' not being declared.

  arch/x86/mm/tlb.c:177:15: warning: symbol
  'tlb_single_page_flush_ceiling' was not declared. Should it be static?

Since it isn't used anywhere outside this file, fix the warning
by making it static.

Also, optimize the use of this variable by adding the
__read_mostly directive, as suggested by David Rientjes.

Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Link: http://lkml.kernel.org/r/1407569913-4035-1-git-send-email-jmmahler@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/tlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 98b7976..ee61c36 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -180,7 +180,7 @@ void flush_tlb_current_task(void)
  *
  * This is in units of pages.
  */
-unsigned long tlb_single_page_flush_ceiling = 33;
+static unsigned long tlb_single_page_flush_ceiling __read_mostly = 33;
 
 void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned long vmflag)
