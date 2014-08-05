Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbaHESaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:30:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbaHESaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:30:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3.4 07/19] Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtime option"
Date: Tue,  5 Aug 2014 11:29:31 -0700
Message-Id: <20140805182934.256139130@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805182934.022406678@linuxfoundation.org>
References: <20140805182934.022406678@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@zytor.com>

commit 7ed6fb9b5a5510e4ef78ab27419184741169978a upstream.

This reverts commit fa81511bb0bbb2b1aace3695ce869da9762624ff in
preparation of merging in the proper fix (espfix64).

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/ldt.c        |    4 +---
 arch/x86/vdso/vdso32-setup.c |    8 --------
 2 files changed, 1 insertion(+), 11 deletions(-)

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
@@ -236,7 +234,7 @@ static int write_ldt(void __user *ptr, u
 	 * IRET leaking the high bits of the kernel stack address.
 	 */
 #ifdef CONFIG_X86_64
-	if (!ldt_info.seg_32bit && !sysctl_ldt16) {
+	if (!ldt_info.seg_32bit) {
 		error = -EINVAL;
 		goto out_unlock;
 	}
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -41,7 +41,6 @@ enum {
 #ifdef CONFIG_X86_64
 #define vdso_enabled			sysctl_vsyscall32
 #define arch_setup_additional_pages	syscall32_setup_pages
-extern int sysctl_ldt16;
 #endif
 
 /*
@@ -380,13 +379,6 @@ static ctl_table abi_table2[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
-	},
-	{
-		.procname	= "ldt16",
-		.data		= &sysctl_ldt16,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec
 	},
 	{}
 };


