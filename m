Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbaIOWXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:23:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51364 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758566AbaIOWUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 038/187] Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtime option"
Date: Mon, 15 Sep 2014 15:07:28 -0700
Message-Id: <1410818997-9432-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@zytor.com>

commit 7ed6fb9b5a5510e4ef78ab27419184741169978a upstream.

This reverts commit fa81511bb0bbb2b1aace3695ce869da9762624ff in
preparation of merging in the proper fix (espfix64).

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/ldt.c        | 4 +---
 arch/x86/vdso/vdso32-setup.c | 8 --------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index dcbbaa1..af1d14a 100644
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
index f1d633a..d6bfb87 100644
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
1.9.1

