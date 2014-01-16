Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaAPNkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:40:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38448 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaAPNkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:40:51 -0500
Date: Thu, 16 Jan 2014 05:40:11 -0800
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-5778fccf361c9ba443b45d822f3d875f64c80084@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, raistlin@linux.it, tglx@linutronix.de,
        fengguang.wu@intel.com, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, raistlin@linux.it, tglx@linutronix.de,
        fengguang.wu@intel.com, juri.lelli@gmail.com
In-Reply-To: <52D5552D.5000102@gmail.com>
References: <52D5552D.5000102@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/core: Fix htmldocs warnings
Git-Commit-ID: 5778fccf361c9ba443b45d822f3d875f64c80084
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:40:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5778fccf361c9ba443b45d822f3d875f64c80084
Gitweb:     http://git.kernel.org/tip/5778fccf361c9ba443b45d822f3d875f64c80084
Author:     Juri Lelli <juri.lelli@gmail.com>
AuthorDate: Tue, 14 Jan 2014 16:10:39 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 16 Jan 2014 09:27:12 +0100

sched/core: Fix htmldocs warnings

Fengguang Wu's kbuild test robot reported the following new htmldocs warnings:

  >>> Warning(kernel/sched/core.c:3380): No description found for parameter 'uattr'
  >>> Warning(kernel/sched/core.c:3380): Excess function parameter 'attr' description in 'sys_sched_setattr'
  >>> Warning(kernel/sched/core.c:3520): No description found for parameter 'uattr'
  >>> Warning(kernel/sched/core.c:3520): Excess function parameter 'attr' description in 'sys_sched_getattr'

The second argument to sys_sched_{setattr,getattr}() is named uattr (not attr).

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Dario Faggioli <raistlin@linux.it>
Fixes: d50dde5a10f3 ("sched: Add new scheduler syscalls to support an extended scheduling parameters ABI")
Link: http://lkml.kernel.org/r/52D5552D.5000102@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 138711b..26af370 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3614,7 +3614,7 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 /**
  * sys_sched_setattr - same as above, but with extended sched_attr
  * @pid: the pid in question.
- * @attr: structure containing the extended parameters.
+ * @uattr: structure containing the extended parameters.
  */
 SYSCALL_DEFINE2(sched_setattr, pid_t, pid, struct sched_attr __user *, uattr)
 {
@@ -3756,7 +3756,7 @@ err_size:
 /**
  * sys_sched_getattr - similar to sched_getparam, but with sched_attr
  * @pid: the pid in question.
- * @attr: structure containing the extended parameters.
+ * @uattr: structure containing the extended parameters.
  * @size: sizeof(attr) for fwd/bwd comp.
  */
 SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
