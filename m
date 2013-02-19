Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab3BSGwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 01:52:22 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:63612 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab3BSGwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 01:52:14 -0500
Message-Id: <20130219065210.148067470@openvz.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 10:48:02 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: ebiederm@xmission.com, xemul@parallels.com, hpa@zytor.com,
        akpm@linux-foundation.org,
        Alexander Kartashov <alekskartashov@parallels.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [patch 2/2] arm: Wire up kcmp syscall
References: <20130219064800.719149796@openvz.org>
Content-Disposition: inline; filename=kcmp-arm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kartashov <alekskartashov@parallels.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/include/uapi/asm/unistd.h |    2 +-
 arch/arm/kernel/calls.S            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/arm/include/uapi/asm/unistd.h
===================================================================
--- linux-2.6.git.orig/arch/arm/include/uapi/asm/unistd.h
+++ linux-2.6.git/arch/arm/include/uapi/asm/unistd.h
@@ -404,7 +404,7 @@
 #define __NR_setns			(__NR_SYSCALL_BASE+375)
 #define __NR_process_vm_readv		(__NR_SYSCALL_BASE+376)
 #define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
-					/* 378 for kcmp */
+#define __NR_kcmp			(__NR_SYSCALL_BASE+378)
 #define __NR_finit_module		(__NR_SYSCALL_BASE+379)
 
 /*
Index: linux-2.6.git/arch/arm/kernel/calls.S
===================================================================
--- linux-2.6.git.orig/arch/arm/kernel/calls.S
+++ linux-2.6.git/arch/arm/kernel/calls.S
@@ -387,7 +387,7 @@
 /* 375 */	CALL(sys_setns)
 		CALL(sys_process_vm_readv)
 		CALL(sys_process_vm_writev)
-		CALL(sys_ni_syscall)	/* reserved for sys_kcmp */
+		CALL(sys_kcmp)
 		CALL(sys_finit_module)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls

