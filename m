Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab3IEJJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:09:04 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:48443 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674Ab3IEJJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:09:01 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] sparc64: Export flush_ptrace_access() (needed by lustre)
Date: Thu,  5 Sep 2013 11:08:29 +0200
Message-Id: <1378372110-19094-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "flush_ptrace_access" [drivers/staging/lustre/lustre/libcfs/libcfs.ko]
undefined!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/sparc/kernel/ptrace_64.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index 7ff45e4..8e7e2f9 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/errno.h>
+#include <linux/export.h>
 #include <linux/ptrace.h>
 #include <linux/user.h>
 #include <linux/smp.h>
@@ -116,6 +117,7 @@ void flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
 
 	preempt_enable();
 }
+EXPORT_SYMBOL(flush_ptrace_access);
 
 static int get_from_target(struct task_struct *target, unsigned long uaddr,
 			   void *kbuf, int len)
-- 
1.7.9.5

