Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaKJJpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:45:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55698 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaKJJpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:45:44 -0500
Date: Mon, 10 Nov 2014 01:45:33 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-07114f0f1cda8b2ef6e884d0c7b268a32cce7903@git.kernel.org>
Cc: hpa@zytor.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, luto@amacapital.net
Reply-To: luto@amacapital.net, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org
In-Reply-To: <23320cb5017c2da8475ec20fcde8089d82aa2699.1415144745.git.luto@amacapital.net>
References: <23320cb5017c2da8475ec20fcde8089d82aa2699.1415144745.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86_64:
  Add a comment explaining the TASK_SIZE_MAX guard page
Git-Commit-ID: 07114f0f1cda8b2ef6e884d0c7b268a32cce7903
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07114f0f1cda8b2ef6e884d0c7b268a32cce7903
Gitweb:     http://git.kernel.org/tip/07114f0f1cda8b2ef6e884d0c7b268a32cce7903
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Tue, 4 Nov 2014 15:46:21 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 10 Nov 2014 10:43:13 +0100

x86_64: Add a comment explaining the TASK_SIZE_MAX guard page

That guard page is absolutely necessary; explain why for
posterity.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/23320cb5017c2da8475ec20fcde8089d82aa2699.1415144745.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/processor.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eb71ec7..82d93ea 100644
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
 
