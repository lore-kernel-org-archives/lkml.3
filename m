Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaEUWHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:07:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34795 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbaEUWHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:07:16 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 1/3] x86_64: Add missing 'DEFAULT_FRAME 0' entry annotations
Date: Wed, 21 May 2014 15:07:07 -0700
Message-Id: <10ad65f534f8bc62e77f74fe15f68e8d4a59d8b3.1400709717.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1400709717.git.luto@amacapital.net>
References: <cover.1400709717.git.luto@amacapital.net>
In-Reply-To: <cover.1400709717.git.luto@amacapital.net>
References: <cover.1400709717.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The paranoidzeroentry macros were missing them.  I'm not at all
convinced that these annotations are correct and/or necessary, but
this makes the macros more consistent with each other.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/entry_64.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c36..39372ec 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1230,6 +1230,7 @@ ENTRY(\sym)
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
+	DEFAULT_FRAME 0
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
@@ -1249,6 +1250,7 @@ ENTRY(\sym)
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
+	DEFAULT_FRAME 0
 	TRACE_IRQS_OFF_DEBUG
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
-- 
1.9.0

