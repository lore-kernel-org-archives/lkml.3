Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbaJ1LQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:16:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51416 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaJ1LQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:16:54 -0400
Date: Tue, 28 Oct 2014 04:16:32 -0700
From: tip-bot for Nicholas Mc Guire <tipbot@zytor.com>
Message-ID: <tip-a1a5831d295f34eceec3ba12c199c2c070e1aaed@git.kernel.org>
Cc: JBeulich@suse.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        der.herr@hofr.at, hpa@zytor.com, torvalds@linux-foundation.org,
        luto@amacapital.net, mingo@kernel.org
Reply-To: der.herr@hofr.at, hpa@zytor.com, luto@amacapital.net,
        torvalds@linux-foundation.org, mingo@kernel.org, JBeulich@suse.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <20141027172805.GA19760@opentech.at>
References: <20141027172805.GA19760@opentech.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/asm: Fix typo in arch/x86/kernel/
 asm_offset_64.c
Git-Commit-ID: a1a5831d295f34eceec3ba12c199c2c070e1aaed
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

Commit-ID:  a1a5831d295f34eceec3ba12c199c2c070e1aaed
Gitweb:     http://git.kernel.org/tip/a1a5831d295f34eceec3ba12c199c2c070e1aaed
Author:     Nicholas Mc Guire <der.herr@hofr.at>
AuthorDate: Mon, 27 Oct 2014 18:28:05 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:24:17 +0100

x86/asm: Fix typo in arch/x86/kernel/asm_offset_64.c

Drop double entry for pt_regs_bx.

This seems to be a typo - resulting in a double entry in the
generated include/generated/asm-offsets.h, which is not necessary.

Build-tested and booted on x86 64 box to make sure it was not
doing any strange magic.... after all it was in the kernel in
this form for almost 10 years.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20141027172805.GA19760@opentech.at
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/asm-offsets_64.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index e7c798b..4f9359f 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -48,7 +48,6 @@ int main(void)
 
 #define ENTRY(entry) OFFSET(pt_regs_ ## entry, pt_regs, entry)
 	ENTRY(bx);
-	ENTRY(bx);
 	ENTRY(cx);
 	ENTRY(dx);
 	ENTRY(sp);
