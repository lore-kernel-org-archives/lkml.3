Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935340Ab3DKNhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:37:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab3DKNhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:37:08 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH] cpa: pageattr-test: fix false positive in CPA self test
Date: Thu, 11 Apr 2013 15:36:09 +0200
Message-Id: <1365687369-30802-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the pmd is not present, _PAGE_PSE will not be set anymore. Fix the
false positive.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/mm/pageattr-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index b008656..0e38951 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -68,7 +68,7 @@ static int print_split(struct split_state *s)
 			s->gpg++;
 			i += GPS/PAGE_SIZE;
 		} else if (level == PG_LEVEL_2M) {
-			if (!(pte_val(*pte) & _PAGE_PSE)) {
+			if ((pte_val(*pte) & _PAGE_PRESENT) && !(pte_val(*pte) & _PAGE_PSE)) {
 				printk(KERN_ERR
 					"%lx level %d but not PSE %Lx\n",
 					addr, level, (u64)pte_val(*pte));
