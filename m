Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763590Ab3IEJR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:17:59 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:33717 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763397Ab3IEJR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:17:58 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2] sparc64: Export flush_ptrace_access() (needed by lustre)
Date: Thu,  5 Sep 2013 11:17:33 +0200
Message-Id: <1378372653-5822-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "flush_ptrace_access" [drivers/staging/lustre/lustre/libcfs/libcfs.ko]
undefined!

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2: Use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL

 arch/sparc/kernel/ptrace_64.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index 7ff45e4..5573998 100644
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
+EXPORT_SYMBOL_GPL(flush_ptrace_access);
 
 static int get_from_target(struct task_struct *target, unsigned long uaddr,
 			   void *kbuf, int len)
-- 
1.7.9.5

