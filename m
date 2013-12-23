Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab3LWV4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:56:10 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:58949 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab3LWVzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:55:51 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 23 Dec 2013 13:55:43 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Bill Metzenthen <billm@melbpc.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] x86: math-emu: Drop already-disabled print of build date
Message-ID: <4bcc0a61c9fcd00792b9b858e4e116db78b8d727.1387833347.git.josh@joshtriplett.org>
References: <cover.1387833347.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387833347.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already has this information, so other bits of kernel code
shouldn't duplicate that.  This also eliminates the use of __DATE__,
which makes the build non-deterministic.

This message was already disabled at build time, with PRINT_MESSAGES
undef'd at the top of the file.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/math-emu/errors.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
index 59d353d..a544908 100644
--- a/arch/x86/math-emu/errors.c
+++ b/arch/x86/math-emu/errors.c
@@ -330,11 +330,6 @@ asmlinkage void FPU_exception(int n)
 
 	RE_ENTRANT_CHECK_OFF;
 	if ((~control_word & n & CW_Exceptions) || (n == EX_INTERNAL)) {
-#ifdef PRINT_MESSAGES
-		/* My message from the sponsor */
-		printk(FPU_VERSION " " __DATE__ " (C) W. Metzenthen.\n");
-#endif /* PRINT_MESSAGES */
-
 		/* Get a name string for error reporting */
 		for (i = 0; exception_names[i].type; i++)
 			if ((exception_names[i].type & n) ==
-- 
1.8.5.2

