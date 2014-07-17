Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933183AbaGQN2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:28:41 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:43258 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaGQN2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:28:39 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-sh@vger.kernel.org
Cc: eparis@redhat.com, Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 3/3] arch/sh/kernel/ptrace_{32,64}.c: drop negativity checks for unsigned long addr
Date: Thu, 17 Jul 2014 16:28:25 +0300
Message-Id: <1405603705-12625-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80381
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 arch/sh/kernel/ptrace_32.c | 4 ++--
 arch/sh/kernel/ptrace_64.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index c1a6b89..78effcb 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -379,7 +379,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		unsigned long tmp;
 
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
+		if ((addr & 3) ||
 		    addr > sizeof(struct user) - 3)
 			break;
 
@@ -419,7 +419,7 @@ long arch_ptrace(struct task_struct *child, long request,
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 		ret = -EIO;
-		if ((addr & 3) || addr < 0 ||
+		if ((addr & 3) ||
 		    addr > sizeof(struct user) - 3)
 			break;
 
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index 5cea973..138b2b1 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -395,7 +395,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		unsigned long tmp;
 
 		ret = -EIO;
-		if ((addr & 3) || addr < 0)
+		if (addr & 3)
 			break;
 
 		if (addr < sizeof(struct pt_regs))
@@ -423,7 +423,7 @@ long arch_ptrace(struct task_struct *child, long request,
                    this could crash the kernel or result in a security
                    loophole. */
 		ret = -EIO;
-		if ((addr & 3) || addr < 0)
+		if (addr & 3)
 			break;
 
 		if (addr < sizeof(struct pt_regs)) {
-- 
1.8.5.5

