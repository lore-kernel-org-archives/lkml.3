Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbaIWClE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:41:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:38622 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbaIWCk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:59 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Guenter Roeck <linux@roeck-us.net>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 41/45] UniCore32-bugfix: Remove definitions in asm/bug.h to solve difference between native and cross compiler
Date: Tue, 23 Sep 2014 10:31:43 +0800
Message-Id: <1411439507-30391-41-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 10e1e99e55378a65529c48753703c069aebce7af upstream.

For kernel/bound.c being compiled by native compiler, it will generate following errors in gcc 4.4.3:
  CC      kernel/bounds.s
In file included from include/linux/bug.h:4,
                 from include/linux/page-flags.h:9,
                 from kernel/bounds.c:9:
arch/unicore32/include/asm/bug.h:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'void'
arch/unicore32/include/asm/bug.h:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'void'

So, we moved definitions in asm/bug.h to arch/unicore32/kernel/setup.h to solve the problem.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/unicore32/include/asm/bug.h |    5 -----
 arch/unicore32/kernel/setup.h    |    6 ++++++
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/unicore32/include/asm/bug.h b/arch/unicore32/include/asm/bug.h
index b1ff8ca..93a56f3 100644
--- a/arch/unicore32/include/asm/bug.h
+++ b/arch/unicore32/include/asm/bug.h
@@ -19,9 +19,4 @@ extern void die(const char *msg, struct pt_regs *regs, int err);
 extern void uc32_notify_die(const char *str, struct pt_regs *regs,
 		struct siginfo *info, unsigned long err, unsigned long trap);
 
-extern asmlinkage void __backtrace(void);
-extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
-
-extern void __show_regs(struct pt_regs *);
-
 #endif /* __UNICORE_BUG_H__ */
diff --git a/arch/unicore32/kernel/setup.h b/arch/unicore32/kernel/setup.h
index f239550..30f749d 100644
--- a/arch/unicore32/kernel/setup.h
+++ b/arch/unicore32/kernel/setup.h
@@ -30,4 +30,10 @@ extern char __vectors_start[], __vectors_end[];
 extern void kernel_thread_helper(void);
 
 extern void __init early_signal_init(void);
+
+extern asmlinkage void __backtrace(void);
+extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
+
+extern void __show_regs(struct pt_regs *);
+
 #endif
-- 
1.7.9.5

