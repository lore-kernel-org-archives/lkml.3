Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3CKSPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:15:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44224 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3CKSPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:15:41 -0400
Date: Mon, 11 Mar 2013 11:14:14 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-ec7fd34425f6536ed4b3548e7aa712ee2718189c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        edumazet@google.com, jbeulich@suse.com, pavel@ucw.cz,
        JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, edumazet@google.com,
        tglx@linutronix.de, pavel@ucw.cz
In-Reply-To: <513DBAA402000078000C4896@nat28.tlf.novell.com>
References: <513DBAA402000078000C4896@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Drop always empty .text..page_aligned section
Git-Commit-ID: ec7fd34425f6536ed4b3548e7aa712ee2718189c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Mar 2013 11:14:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec7fd34425f6536ed4b3548e7aa712ee2718189c
Gitweb:     http://git.kernel.org/tip/ec7fd34425f6536ed4b3548e7aa712ee2718189c
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 11 Mar 2013 10:06:12 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Mar 2013 15:07:56 +0100

x86: Drop always empty .text..page_aligned section

Commit e44b7b7 ("x86: move suspend wakeup code to C") didn't
care to also eliminate the side effects that the earlier 4c49156
("x86: make arch/x86/kernel/acpi/wakeup_32.S use a separate")
had, thus leaving a now pointless, almost page size gap at the
beginning of .text.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Pavel Machek <pavel@ucw.cz>
Link: http://lkml.kernel.org/r/513DBAA402000078000C4896@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/acpi/wakeup_32.S | 2 +-
 arch/x86/kernel/vmlinux.lds.S    | 4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kernel/acpi/wakeup_32.S b/arch/x86/kernel/acpi/wakeup_32.S
index 13ab720..ced4638 100644
--- a/arch/x86/kernel/acpi/wakeup_32.S
+++ b/arch/x86/kernel/acpi/wakeup_32.S
@@ -1,4 +1,4 @@
-	.section .text..page_aligned
+	.text
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 22a1530..10c4f30 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
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
