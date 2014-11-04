Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaKDXq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:46:29 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:61194 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaKDXq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:46:28 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86_64: Add a comment explaining the TASK_SIZE_MAX guard page
Date: Tue,  4 Nov 2014 15:46:21 -0800
Message-Id: <23320cb5017c2da8475ec20fcde8089d82aa2699.1415144745.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That guard page is absolutely necessary; explain why for posterity.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/processor.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eb71ec794732..82d93ea13c0c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -893,7 +893,13 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
 
 #else
 /*
- * User space process size. 47bits minus one guard page.
+ * User space process size. 47bits minus one guard page.  The guard
+ * page is necessary on Intel CPUs: if a SYSCALL instruction is at
+ * the highest possible canonical userspace address, then that
+ * syscall will enter the kernel with a non-canonical return
+ * address, and SYSRET will explode dangerously.  We avoid this
+ * particular problem by preventing anything from being mapped
+ * at the maximum canonical address.
  */
 #define TASK_SIZE_MAX	((1UL << 47) - PAGE_SIZE)
 
-- 
1.9.3

