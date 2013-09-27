Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab3I0Oes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:34:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40593 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab3I0Oep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:34:45 -0400
Date: Fri, 27 Sep 2013 16:34:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: [PATCH 1/2] x86, alternatives: Drop ancient lockdep fixup message
Message-ID: <20130927143442.GE4422@pd.tnic>
References: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
 <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
 <20130925100722.GB3433@nazgul.tnic>
 <20130925182936.GD16693@gmail.com>
 <20130926231545.GD10123@pd.tnic>
 <20130927065115.GA6852@gmail.com>
 <20130927103802.GA4422@pd.tnic>
 <20130927143249.GD4422@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130927143249.GD4422@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

It messes up the output of the nodes/cores bootup table and it is
obsolete anyway, see

  17abecfe651c x86: fix up alternatives with lockdep enabled

Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/20130927065115.GA6852@gmail.com
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/alternative.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 15e8563e5c24..df94598ad05a 100644
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
 
-- 
1.8.4

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
