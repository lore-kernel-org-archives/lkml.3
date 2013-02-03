Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab3BCMqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 07:46:31 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:59718 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3BCMq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 07:46:29 -0500
From: Artem Savkov <artem.savkov@gmail.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH] asmlinkage tag for sys_iopl
Date: Sun,  3 Feb 2013 16:46:22 +0400
Message-Id: <1359895582-5482-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asmlinkage tag seems to be missing from sys_iopl prototype rendering iopl
syscalls unusable, i.e. every call returns -EINVAL. Most likely introduced in
9e0b2428bc6a6c6df90bb701ca843820727cadf0.

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
---
 arch/x86/include/asm/syscalls.h | 2 +-
 arch/x86/kernel/ioport.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 13f078c..6cf0a9c 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -18,7 +18,7 @@
 /* Common in X86_32 and X86_64 */
 /* kernel/ioport.c */
 asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
-long sys_iopl(unsigned int);
+asmlinkage long sys_iopl(unsigned int);
 
 /* kernel/ldt.c */
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 5f98381..b1127a0 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -93,7 +93,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
  * on system-call entry - see also fork() and the signal handling
  * code.
  */
-long sys_iopl(unsigned int level)
+asmlinkage long sys_iopl(unsigned int level)
 {
 	struct pt_regs *regs = current_pt_regs();
 	unsigned int old = (regs->flags >> 12) & 3;
-- 
1.8.1.1

