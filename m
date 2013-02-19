Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3BSHHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 02:07:09 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:65093 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3BSHHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 02:07:08 -0500
Date: Tue, 19 Feb 2013 11:07:03 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, xemul@parallels.com,
        hpa@zytor.com, akpm@linux-foundation.org,
        Alexander Kartashov <alekskartashov@parallels.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [patch 2/2] arm: Wire up kcmp syscall
Message-ID: <20130219070703.GC20312@moon>
References: <20130219064800.719149796@openvz.org>
 <20130219065210.148067470@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219065210.148067470@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

quilt eat original header, here is the former, sorry
for incovenience.
---
From: Alexander Kartashov <alekskartashov@parallels.com>
Subject: arm: Wire up kcmp syscall

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
