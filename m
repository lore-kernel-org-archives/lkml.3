Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3CFA0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:26:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38146 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3CFA0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:26:15 -0500
Date: Tue, 5 Mar 2013 16:24:02 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-576cfb404c9cab728e9462ea713f3422679d5cf7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de,
        len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com,
        len.brown@intel.com
In-Reply-To: <1362428180-8865-2-git-send-email-bp@alien8.de>
References: <1362428180-8865-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, smpboot: Remove unused variable
Git-Commit-ID: 576cfb404c9cab728e9462ea713f3422679d5cf7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 05 Mar 2013 16:24:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  576cfb404c9cab728e9462ea713f3422679d5cf7
Gitweb:     http://git.kernel.org/tip/576cfb404c9cab728e9462ea713f3422679d5cf7
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 4 Mar 2013 21:16:16 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 5 Mar 2013 15:26:45 -0800

x86, smpboot: Remove unused variable

The cpuinfo_x86 ptr is unused now. Drop it. Got obsolete by 69fb3676df33
("x86 idle: remove mwait_idle() and "idle=mwait" cmdline param")
removing its only user.

[ hpa: fixes gcc warning ]

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1362428180-8865-2-git-send-email-bp@alien8.de
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/smpboot.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a6ceaed..9f190a2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1365,9 +1365,8 @@ static inline void mwait_play_dead(void)
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int highest_cstate = 0;
 	unsigned int highest_subcstate = 0;
-	int i;
 	void *mwait_ptr;
-	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
+	int i;
 
 	if (!this_cpu_has(X86_FEATURE_MWAIT))
 		return;
