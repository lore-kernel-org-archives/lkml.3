Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaJ0R2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:28:10 -0400
Received: from hofr.at ([212.69.189.236]:52970 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbaJ0R2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:28:07 -0400
Date: Mon, 27 Oct 2014 18:28:05 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: typo fix in arch/x86/kernel/asm_offset_64.c
Message-ID: <20141027172805.GA19760@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


drope double entry for pt_regs_bx

This seems to be a typo - resulting in a double entry in the
generated include/generated/asm-offsets.h which is not necessary

Build-tested and booted on x86 64 box to make sure it was not
doing any strange magic.... after all it was in the kernel in
this form for almost 10 years.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 arch/x86/kernel/asm-offsets_64.c |    1 -
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
-- 
1.7.10.4

