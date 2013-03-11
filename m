Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3CKKGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:06:18 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:43756 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3CKKGR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 11 Mar 2013 06:06:17 -0400
Message-Id: <513DBAA402000078000C4896@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 11 Mar 2013 10:06:12 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <edumazet@google.com>, <pavel@ucw.cz>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ix86: drop always empty .text..page_aligned section
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e44b7b7 ("x86: move suspend wakeup code to C") didn't care to
also eliminate the side effects that the earlier 4c49156 ("x86: make
arch/x86/kernel/acpi/wakeup_32.S use a separate") had, thus leaving a
now pointless, almost page size gap at the beginning of .text.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Pavel Machek <pavel@ucw.cz>

---
 arch/x86/kernel/acpi/wakeup_32.S |    2 +-
 arch/x86/kernel/vmlinux.lds.S    |    4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

--- 3.9-rc2/arch/x86/kernel/acpi/wakeup_32.S
+++ 3.9-rc2-ix86-no-page-aligned-text/arch/x86/kernel/acpi/wakeup_32.S
@@ -1,4 +1,4 @@
-	.section .text..page_aligned
+	.text
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
--- 3.9-rc2/arch/x86/kernel/vmlinux.lds.S
+++ 3.9-rc2-ix86-no-page-aligned-text/arch/x86/kernel/vmlinux.lds.S
@@ -94,10 +94,6 @@ SECTIONS
 		_text = .;
 		/* bootstrapping code */
 		HEAD_TEXT
-#ifdef CONFIG_X86_32
-		. = ALIGN(PAGE_SIZE);
-		*(.text..page_aligned)
-#endif
 		. = ALIGN(8);
 		_stext = .;
 		TEXT_TEXT



