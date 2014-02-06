Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbaBFSuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:50:05 -0500
Received: from mail.windriver.com ([147.11.1.11]:53606 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaBFSuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:50:04 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
Subject: [PATCH] smp.h: fix x86+cpu.c sparse warnings about arch nonboot CPU calls
Date: Thu, 6 Feb 2014 13:49:36 -0500
Message-ID: <1391712576-2566-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use what we already do for arch_disable_smp_support() to fix these:

  arch/x86/kernel/smpboot.c:1155:6: warning: symbol 'arch_enable_nonboot_cpus_begin' was not declared. Should it be static?
  arch/x86/kernel/smpboot.c:1160:6: warning: symbol 'arch_enable_nonboot_cpus_end' was not declared. Should it be static?
  kernel/cpu.c:512:13: warning: symbol 'arch_enable_nonboot_cpus_begin' was not declared. Should it be static?
  kernel/cpu.c:516:13: warning: symbol 'arch_enable_nonboot_cpus_end' was not declared. Should it be static?

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/smp.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 3834f43f9993..6ae004e437ea 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -188,6 +188,9 @@ static inline void kick_all_cpus_sync(void) {  }
  */
 extern void arch_disable_smp_support(void);
 
+extern void arch_enable_nonboot_cpus_begin(void);
+extern void arch_enable_nonboot_cpus_end(void);
+
 void smp_setup_processor_id(void);
 
 #endif /* __LINUX_SMP_H */
-- 
1.8.5.2

