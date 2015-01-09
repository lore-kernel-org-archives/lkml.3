Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbbAIP5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:57:48 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58954 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbbAIP5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:57:46 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 5/5] arm64: make sys_call_table const
Date: Fri,  9 Jan 2015 15:57:28 +0000
Message-Id: <1420819048-3515-6-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420819048-3515-1-git-send-email-catalin.marinas@arm.com>
References: <1420819048-3515-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

As with x86, mark the sys_call_table const such that it will be placed
in the .rodata section. This will cause attempts to modify the table
(accidental or deliberate) to fail when strict page permissions are in
place. In the absence of strict page permissions, there should be no
functional change.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/sys.c b/arch/arm64/kernel/sys.c
index dec351a9f3d6..75151aaf1a52 100644
--- a/arch/arm64/kernel/sys.c
+++ b/arch/arm64/kernel/sys.c
@@ -49,7 +49,7 @@ asmlinkage long sys_rt_sigreturn_wrapper(void);
  * The sys_call_table array must be 4K aligned to be accessible from
  * kernel/entry.S.
  */
-void *sys_call_table[__NR_syscalls] __aligned(4096) = {
+void * const sys_call_table[__NR_syscalls] __aligned(4096) = {
 	[0 ... __NR_syscalls - 1] = sys_ni_syscall,
 #include <asm/unistd.h>
 };
