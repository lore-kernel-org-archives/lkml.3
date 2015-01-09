Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbbAIP6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:58:14 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58943 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757718AbbAIP5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:57:40 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/5] arm64: Remove asm/syscalls.h
Date: Fri,  9 Jan 2015 15:57:27 +0000
Message-Id: <1420819048-3515-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420819048-3515-1-git-send-email-catalin.marinas@arm.com>
References: <1420819048-3515-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the sys_rt_sigreturn_wrapper prototype to
arch/arm64/kernel/sys.c and removes the asm/syscalls.h header.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/syscalls.h | 30 ------------------------------
 arch/arm64/kernel/sys.c           |  3 +--
 2 files changed, 1 insertion(+), 32 deletions(-)
 delete mode 100644 arch/arm64/include/asm/syscalls.h

diff --git a/arch/arm64/include/asm/syscalls.h b/arch/arm64/include/asm/syscalls.h
deleted file mode 100644
index 48fe7c600e98..000000000000
--- a/arch/arm64/include/asm/syscalls.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Copyright (C) 2012 ARM Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-#ifndef __ASM_SYSCALLS_H
-#define __ASM_SYSCALLS_H
-
-#include <linux/linkage.h>
-#include <linux/compiler.h>
-#include <linux/signal.h>
-
-/*
- * System call wrappers implemented in kernel/entry.S.
- */
-asmlinkage long sys_rt_sigreturn_wrapper(void);
-
-#include <asm-generic/syscalls.h>
-
-#endif	/* __ASM_SYSCALLS_H */
diff --git a/arch/arm64/kernel/sys.c b/arch/arm64/kernel/sys.c
index 3fa98ff14f0e..dec351a9f3d6 100644
--- a/arch/arm64/kernel/sys.c
+++ b/arch/arm64/kernel/sys.c
@@ -39,10 +39,9 @@ asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
 /*
  * Wrappers to pass the pt_regs argument.
  */
+asmlinkage long sys_rt_sigreturn_wrapper(void);
 #define sys_rt_sigreturn	sys_rt_sigreturn_wrapper
 
-#include <asm/syscalls.h>
-
 #undef __SYSCALL
 #define __SYSCALL(nr, sym)	[nr] = sym,
 
