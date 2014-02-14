Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaBNECD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:02:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47857 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaBND7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 22:59:07 -0500
Date: Thu, 13 Feb 2014 19:58:32 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-63f9a7fde715352e0769302527670542a664b981@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1391845930-28580-5-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-5-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] asmlinkage: Make lockdep_sys_exit asmlinkage
Git-Commit-ID: 63f9a7fde715352e0769302527670542a664b981
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 19:58:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63f9a7fde715352e0769302527670542a664b981
Gitweb:     http://git.kernel.org/tip/63f9a7fde715352e0769302527670542a664b981
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 08:52:01 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 18:12:54 -0800

asmlinkage: Make lockdep_sys_exit asmlinkage

lockdep_sys_exit can be called from assembler code, so make it
asmlinkage.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391845930-28580-5-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/lockdep.h  | 2 +-
 kernel/locking/lockdep.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 92b1bfc..7df9aa6 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -265,7 +265,7 @@ extern void lockdep_info(void);
 extern void lockdep_reset(void);
 extern void lockdep_reset_lock(struct lockdep_map *lock);
 extern void lockdep_free_key_range(void *start, unsigned long size);
-extern void lockdep_sys_exit(void);
+extern asmlinkage void lockdep_sys_exit(void);
 
 extern void lockdep_off(void);
 extern void lockdep_on(void);
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index eb8a547..c8b6753c 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -4191,7 +4191,7 @@ void debug_show_held_locks(struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
 
-void lockdep_sys_exit(void)
+asmlinkage void lockdep_sys_exit(void)
 {
 	struct task_struct *curr = current;
 
