Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab3ETSub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:50:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59041 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3ETSua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:50:30 -0400
Date: Mon, 20 May 2013 11:50:12 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-3a6a27dbe46298ee78a4135fa43c11f6bb3f8a6c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, mhocko@suse.cz,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, hpa@linux.intel.com,
        mhocko@suse.cz
In-Reply-To: <20130520182306.GA5348@dhcp22.suse.cz>
References: <20130520182306.GA5348@dhcp22.suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64: Make early_pmd_flags __cpuinitdata
Git-Commit-ID: 3a6a27dbe46298ee78a4135fa43c11f6bb3f8a6c
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

Commit-ID:  3a6a27dbe46298ee78a4135fa43c11f6bb3f8a6c
Gitweb:     http://git.kernel.org/tip/3a6a27dbe46298ee78a4135fa43c11f6bb3f8a6c
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 20 May 2013 11:30:16 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 20 May 2013 11:44:52 -0700

x86-64: Make early_pmd_flags __cpuinitdata

Although early_pmd_flags is not actually *used* except at init time, it
is *set* in secondary_startup_64, which is executed on any CPU
startup, including hotplug and S3 resume.

Originally-by: Michal Hocko <mhocko@suse.cz>
Reported-and-tested-by: Michal Hocko <mhocko@suse.cz>
Debugged-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20130520182306.GA5348@dhcp22.suse.cz
Cc: <stable@vger.kernel.org> v3.9
---
 arch/x86/kernel/head64.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index dab95a8..aa67bdd 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -34,7 +34,8 @@
 extern pgd_t early_level4_pgt[PTRS_PER_PGD];
 extern pmd_t early_dynamic_pgts[EARLY_DYNAMIC_PAGE_TABLES][PTRS_PER_PMD];
 static unsigned int __initdata next_early_pgt = 2;
-pmdval_t __initdata early_pmd_flags = __PAGE_KERNEL_LARGE & ~(_PAGE_GLOBAL | _PAGE_NX);
+pmdval_t __cpuinitdata early_pmd_flags =
+	__PAGE_KERNEL_LARGE & ~(_PAGE_GLOBAL | _PAGE_NX);
 
 /* Wipe all early page tables except for the kernel symbol map */
 static void __init reset_early_page_tables(void)
