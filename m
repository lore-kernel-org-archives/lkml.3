Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaB1RHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:07:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53659 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbaB1RHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:07:40 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, crash: Unify ifdef
Date: Fri, 28 Feb 2014 18:07:36 +0100
Message-Id: <1393607256-13184-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Merge two back-to-back CONFIG_X86_32 ifdefs into one.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/crash.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index a57902efe2d5..507de8066594 100644
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
-- 
1.9.0

