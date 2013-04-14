Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab3DNQIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:08:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48151 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3DNQIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:08:09 -0400
Date: Sun, 14 Apr 2013 09:06:39 -0700
From: tip-bot for Andrea Arcangeli <tipbot@zytor.com>
Message-ID: <tip-18699739b60cb60230153ff5475b2ba92be185f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        apw@canonical.com, bp@alien8.de, stefan.bader@canonical.com,
        aarcange@redhat.com, mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        apw@canonical.com, stefan.bader@canonical.com, bp@alien8.de,
        aarcange@redhat.com, mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <1365687369-30802-1-git-send-email-aarcange@redhat.com>
References: <1365687369-30802-1-git-send-email-aarcange@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm/cpa/selftest:
  Fix false positive in CPA self test
Git-Commit-ID: 18699739b60cb60230153ff5475b2ba92be185f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 14 Apr 2013 09:06:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18699739b60cb60230153ff5475b2ba92be185f9
Gitweb:     http://git.kernel.org/tip/18699739b60cb60230153ff5475b2ba92be185f9
Author:     Andrea Arcangeli <aarcange@redhat.com>
AuthorDate: Thu, 11 Apr 2013 15:36:09 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Apr 2013 06:39:20 +0200

x86/mm/cpa/selftest: Fix false positive in CPA self test

If the pmd is not present, _PAGE_PSE will not be set anymore.
Fix the false positive.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Stefan Bader <stefan.bader@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1365687369-30802-1-git-send-email-aarcange@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
