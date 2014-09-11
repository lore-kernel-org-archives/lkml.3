Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaIKNGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:06:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499AbaIKNEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:47 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 11 Sep 2014 13:32:14 +0100
Message-ID: <lsq.1410438734.964318026@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 123/131] Revert "x86-64, modify_ldt: Make support for
 16-bit  segments a runtime option"
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@zytor.com>

commit 7ed6fb9b5a5510e4ef78ab27419184741169978a upstream.

This reverts commit fa81511bb0bbb2b1aace3695ce869da9762624ff in
preparation of merging in the proper fix (espfix64).

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/ldt.c        | 4 +---
 arch/x86/vdso/vdso32-setup.c | 8 --------
 2 files changed, 1 insertion(+), 11 deletions(-)

--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -21,8 +21,6 @@
 #include <asm/mmu_context.h>
 #include <asm/syscalls.h>
 
-int sysctl_ldt16 = 0;
-
 #ifdef CONFIG_SMP
 static void flush_ldt(void *current_mm)
 {
@@ -237,7 +235,7 @@ static int write_ldt(void __user *ptr, u
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
@@ -388,13 +387,6 @@ static ctl_table abi_table2[] = {
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

