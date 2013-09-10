Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab3IJHv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:51:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37862 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3IJHv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:51:56 -0400
Date: Tue, 10 Sep 2013 00:51:38 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-c0da0fa1d7ebe3c86747b10c92e0ac2be1524a8a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, viro@zeniv.linux.org.uk, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, viro@zeniv.linux.org.uk
In-Reply-To: <1378546750-19727-1-git-send-email-bp@suse.de>
References: <1378546750-19727-1-git-send-email-bp@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Remove now-unused save_rest()
Git-Commit-ID: c0da0fa1d7ebe3c86747b10c92e0ac2be1524a8a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 10 Sep 2013 00:51:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0da0fa1d7ebe3c86747b10c92e0ac2be1524a8a
Gitweb:     http://git.kernel.org/tip/c0da0fa1d7ebe3c86747b10c92e0ac2be1524a8a
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sat, 7 Sep 2013 11:39:10 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 10 Sep 2013 09:31:55 +0200

x86: Remove now-unused save_rest()

b3af11afe06a ("x86: get rid of pt_regs argument of iopl(2)")
dropped PTREGSCALL which was also the last user of save_rest.
Drop that now-unused function too.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Link: http://lkml.kernel.org/r/1378546750-19727-1-git-send-email-bp@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/entry_64.S | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1b69951..b077f4c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -487,21 +487,6 @@ ENDPROC(native_usergs_sysret64)
 	TRACE_IRQS_OFF
 	.endm
 
-ENTRY(save_rest)
-	PARTIAL_FRAME 1 (REST_SKIP+8)
-	movq 5*8+16(%rsp), %r11	/* save return address */
-	movq_cfi rbx, RBX+16
-	movq_cfi rbp, RBP+16
-	movq_cfi r12, R12+16
-	movq_cfi r13, R13+16
-	movq_cfi r14, R14+16
-	movq_cfi r15, R15+16
-	movq %r11, 8(%rsp)	/* return address */
-	FIXUP_TOP_OF_STACK %r11, 16
-	ret
-	CFI_ENDPROC
-END(save_rest)
-
 /* save complete stack frame */
 	.pushsection .kprobes.text, "ax"
 ENTRY(save_paranoid)
