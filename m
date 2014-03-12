Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaCLONO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:13:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46057 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbaCLONK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:13:10 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86, crash: Unify ifdef
Date: Wed, 12 Mar 2014 15:13:03 +0100
Message-Id: <1394633584-5509-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394633584-5509-1-git-send-email-bp@alien8.de>
References: <1394633584-5509-1-git-send-email-bp@alien8.de>
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

