Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab3I1I3O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 04:29:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44496 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3I1I3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 04:29:10 -0400
Date: Sat, 28 Sep 2013 01:28:40 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-2a929242ee50db84c1a561c81897bb0551f2c32f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <20130927143442.GE4422@pd.tnic>
References: <20130927143442.GE4422@pd.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep, x86/alternatives:
  Drop ancient lockdep fixup message
Git-Commit-ID: 2a929242ee50db84c1a561c81897bb0551f2c32f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 28 Sep 2013 01:28:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a929242ee50db84c1a561c81897bb0551f2c32f
Gitweb:     http://git.kernel.org/tip/2a929242ee50db84c1a561c81897bb0551f2c32f
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Fri, 27 Sep 2013 16:34:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 28 Sep 2013 10:09:41 +0200

lockdep, x86/alternatives: Drop ancient lockdep fixup message

It messes up the output of the nodes/cores bootup table and it
is obsolete anyway, see

  17abecfe651c x86: fix up alternatives with lockdep enabled

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: huawei.libin@huawei.com
Cc: wangyijing@huawei.com
Cc: fenghua.yu@intel.com
Cc: guohanjun@huawei.com
Cc: paul.gortmaker@windriver.com
Link: http://lkml.kernel.org/r/20130927143442.GE4422@pd.tnic
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/alternative.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 15e8563..df94598 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -402,17 +402,6 @@ void alternatives_enable_smp(void)
 {
 	struct smp_alt_module *mod;
 
-#ifdef CONFIG_LOCKDEP
-	/*
-	 * Older binutils section handling bug prevented
-	 * alternatives-replacement from working reliably.
-	 *
-	 * If this still occurs then you should see a hang
-	 * or crash shortly after this line:
-	 */
-	pr_info("lockdep: fixing up alternatives\n");
-#endif
-
 	/* Why bother if there are no other CPUs? */
 	BUG_ON(num_possible_cpus() == 1);
 
