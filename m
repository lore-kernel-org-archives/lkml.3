Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab3AXUq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:46:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab3AXUqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:46:18 -0500
Date: Thu, 24 Jan 2013 12:45:57 -0800
From: tip-bot for Chen Gang <gang.chen@asianux.com>
Message-ID: <tip-349eab6eb07794c59e37703ccbfeb5920721885c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gang.chen@asianux.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gang.chen@asianux.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86/process: Change %8s to %s for pr_warn()
  in release_thread()
Git-Commit-ID: 349eab6eb07794c59e37703ccbfeb5920721885c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:46:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  349eab6eb07794c59e37703ccbfeb5920721885c
Gitweb:     http://git.kernel.org/tip/349eab6eb07794c59e37703ccbfeb5920721885c
Author:     Chen Gang <gang.chen@asianux.com>
AuthorDate: Tue, 6 Nov 2012 14:45:46 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 18:11:03 +0100

x86/process: Change %8s to %s for pr_warn() in release_thread()

the length of dead_task->comm[] is 16 (TASK_COMM_LEN)
on pr_warn(), it is not meaningful to use %8s for task->comm[].

So change it to %s, since the line is not solid anyway.

Additional information:

 %8s  limit the width, not for the original string output length
      if name length is more than 8, it still can be fully displayed.
      if name length is less than 8, the ' ' will be filled before name.

 %.8s truly limit the original string output length (precision)

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Link: http://lkml.kernel.org/n/tip-nridm1zvreai1tgfLjuexDmd@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/process_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6e68a61..0f49677 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -117,7 +117,7 @@ void release_thread(struct task_struct *dead_task)
 {
 	if (dead_task->mm) {
 		if (dead_task->mm->context.size) {
-			pr_warn("WARNING: dead process %8s still has LDT? <%p/%d>\n",
+			pr_warn("WARNING: dead process %s still has LDT? <%p/%d>\n",
 				dead_task->comm,
 				dead_task->mm->context.ldt,
 				dead_task->mm->context.size);
