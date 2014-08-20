Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaHTMKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:10:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58884 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 019/104] Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtime option"
Date: Wed, 20 Aug 2014 13:42:42 +0200
Message-Id: <a7b4794cc25bdfb541d77f190fee9784542927ef.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7ed6fb9b5a5510e4ef78ab27419184741169978a upstream.

This reverts commit fa81511bb0bbb2b1aace3695ce869da9762624ff in
preparation of merging in the proper fix (espfix64).

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/ldt.c        | 4 +---
 arch/x86/vdso/vdso32-setup.c | 8 --------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index dcbbaa165bde..af1d14a9ebda 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -20,8 +20,6 @@
 #include <asm/mmu_context.h>
 #include <asm/syscalls.h>
 
-int sysctl_ldt16 = 0;
-
 #ifdef CONFIG_SMP
 static void flush_ldt(void *current_mm)
 {
@@ -236,7 +234,7 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
 	 * IRET leaking the high bits of the kernel stack address.
 	 */
 #ifdef CONFIG_X86_64
-	if (!ldt_info.seg_32bit && !sysctl_ldt16) {
+	if (!ldt_info.seg_32bit) {
 		error = -EINVAL;
 		goto out_unlock;
 	}
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index f1d633a43f8e..d6bfb876cfb0 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -41,7 +41,6 @@ enum {
 #ifdef CONFIG_X86_64
 #define vdso_enabled			sysctl_vsyscall32
 #define arch_setup_additional_pages	syscall32_setup_pages
-extern int sysctl_ldt16;
 #endif
 
 /*
@@ -381,13 +380,6 @@ static struct ctl_table abi_table2[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
-	{
-		.procname	= "ldt16",
-		.data		= &sysctl_ldt16,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec
-	},
 	{}
 };
 
-- 
2.0.4

