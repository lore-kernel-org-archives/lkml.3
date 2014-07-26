Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138AbaGZVtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 17:49:00 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37800 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaGZVs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 17:48:58 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: x86: ia32: ia32_aout.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 23:50:23 +0200
Message-Id: <1406411423-6964-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
And use the sizeof on the to string rather than the from string.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/x86/ia32/ia32_aout.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index d21ff89..1a5eb43 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -156,7 +156,7 @@ static int aout_core_dump(struct coredump_params *cprm)
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 	has_dumped = 1;
-	strncpy(dump.u_comm, current->comm, sizeof(current->comm));
+	strlcpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
 	dump.u_ar0 = offsetof(struct user32, regs);
 	dump.signal = cprm->siginfo->si_signo;
 	dump_thread32(cprm->regs, &dump);
-- 
1.7.10.4

