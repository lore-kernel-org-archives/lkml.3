Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbaBUVe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:34:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaBUVez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:34:55 -0500
Date: Fri, 21 Feb 2014 13:34:04 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-4870c6e5774424c994bfd606cd8adb8818e8a85c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, holt@sgi.com, viro@zeniv.linux.org.uk,
        ebiederm@xmission.com, keescook@chromium.org,
        akpm@linux-foundation.org, sfr@canb.auug.org.au, tglx@linutronix.de,
        oleg@redhat.com, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        holt@sgi.com, peterz@infradead.org, viro@zeniv.linux.org.uk,
        ebiederm@xmission.com, keescook@chromium.org,
        akpm@linux-foundation.org, oleg@redhat.com, tglx@linutronix.de,
        sfr@canb.auug.org.au, yangds.fnst@cn.fujitsu.com
In-Reply-To: <0261f094b836f1acbcdf52e7166487c0c77323c8.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <0261f094b836f1acbcdf52e7166487c0c77323c8.1392103744.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sys:
  Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.
Git-Commit-ID: 4870c6e5774424c994bfd606cd8adb8818e8a85c
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

Commit-ID:  4870c6e5774424c994bfd606cd8adb8818e8a85c
Gitweb:     http://git.kernel.org/tip/4870c6e5774424c994bfd606cd8adb8818e8a85c
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Feb 2014 15:34:51 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:21 +0100

sys: Replace hardcoding of -20 and 19 with MIN_NICE and MAX_NICE.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/0261f094b836f1acbcdf52e7166487c0c77323c8.1392103744.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sys.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index c0a58be..adaeab6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -174,10 +174,10 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 
 	/* normalize: avoid signed division (rounding problems) */
 	error = -ESRCH;
-	if (niceval < -20)
-		niceval = -20;
-	if (niceval > 19)
-		niceval = 19;
+	if (niceval < MIN_NICE)
+		niceval = MIN_NICE;
+	if (niceval > MAX_NICE)
+		niceval = MAX_NICE;
 
 	rcu_read_lock();
 	read_lock(&tasklist_lock);
