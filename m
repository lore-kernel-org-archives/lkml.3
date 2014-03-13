Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbaCMWhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:37:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44976 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaCMWhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:37:07 -0400
Date: Thu, 13 Mar 2014 15:36:52 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-5314feebabd92535a16295a8067b3fd79815cd16@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1394633584-5509-3-git-send-email-bp@alien8.de>
References: <1394633584-5509-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, crash: Unify ifdef
Git-Commit-ID: 5314feebabd92535a16295a8067b3fd79815cd16
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

Commit-ID:  5314feebabd92535a16295a8067b3fd79815cd16
Gitweb:     http://git.kernel.org/tip/5314feebabd92535a16295a8067b3fd79815cd16
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 12 Mar 2014 15:13:03 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Mar 2014 15:32:44 -0700

x86, crash: Unify ifdef

Merge two back-to-back CONFIG_X86_32 ifdefs into one.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1394633584-5509-3-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/crash.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index a57902e..507de80 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -57,9 +57,7 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 {
 #ifdef CONFIG_X86_32
 	struct pt_regs fixed_regs;
-#endif
 
-#ifdef CONFIG_X86_32
 	if (!user_mode_vm(regs)) {
 		crash_fixup_ss_esp(&fixed_regs, regs);
 		regs = &fixed_regs;
