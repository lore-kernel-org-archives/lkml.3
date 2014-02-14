Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaBNEbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:31:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaBNEbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:31:20 -0500
Date: Thu, 13 Feb 2014 20:31:09 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-58edae3aac9f2ccd1afb12ea08127e840a0a706c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391846481-31491-6-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-6-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] lto: Disable LTO for sys_ni
Git-Commit-ID: 58edae3aac9f2ccd1afb12ea08127e840a0a706c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 20:31:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58edae3aac9f2ccd1afb12ea08127e840a0a706c
Gitweb:     http://git.kernel.org/tip/58edae3aac9f2ccd1afb12ea08127e840a0a706c
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 09:01:10 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 20:24:53 -0800

lto: Disable LTO for sys_ni

The assembler alias code in cond_syscall does not work
when compiled for LTO. Just disable LTO for that file.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391846481-31491-6-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/Makefile b/kernel/Makefile
index bc010ee..31c26c6 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -18,6 +18,9 @@ CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_irq_work.o = -pg
 endif
 
+# cond_syscall is currently not LTO compatible
+CFLAGS_sys_ni.o = $(DISABLE_LTO)
+
 obj-y += sched/
 obj-y += locking/
 obj-y += power/
