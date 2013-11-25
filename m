Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3KYXVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:21:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35431 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3KYXVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:21:16 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] mips: Fix build error seen in some configurations
Date: Mon, 25 Nov 2013 15:21:00 -0800
Message-Id: <1385421660-5608-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following build error is seen if CONFIG_32BIT is undefined,
CONFIG_64BIT is defined, and CONFIG_MIPS32_O32 is undefined.

asm/syscall.h: In function 'mips_get_syscall_arg':
arch/mips/include/asm/syscall.h:32:16: error: unused variable 'usp' [-Werror=unused-variable]
cc1: all warnings being treated as errors

Fixes: c0ff3c53d4f9 ('MIPS: Enable HAVE_ARCH_TRACEHOOK')
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/mips/include/asm/syscall.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/syscall.h b/arch/mips/include/asm/syscall.h
index 81c8913..33e8dbf 100644
--- a/arch/mips/include/asm/syscall.h
+++ b/arch/mips/include/asm/syscall.h
@@ -29,7 +29,7 @@ static inline long syscall_get_nr(struct task_struct *task,
 static inline unsigned long mips_get_syscall_arg(unsigned long *arg,
 	struct task_struct *task, struct pt_regs *regs, unsigned int n)
 {
-	unsigned long usp = regs->regs[29];
+	unsigned long usp __maybe_unused = regs->regs[29];
 
 	switch (n) {
 	case 0: case 1: case 2: case 3:
-- 
1.7.9.7

