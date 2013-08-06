Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3HFVo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:44:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43555 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab3HFVox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:44:53 -0400
Date: Tue, 6 Aug 2013 14:44:42 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-b6c035d04e80b4244a143e34e51c84cf2181bd94@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-15-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-15-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage: Make dump_stack visible
Git-Commit-ID: b6c035d04e80b4244a143e34e51c84cf2181bd94
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:44:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b6c035d04e80b4244a143e34e51c84cf2181bd94
Gitweb:     http://git.kernel.org/tip/b6c035d04e80b4244a143e34e51c84cf2181bd94
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:48 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:21:01 -0700

x86, asmlinkage: Make dump_stack visible

dump_stack is used from assembler code, so make it visible.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-15-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/printk.h | 2 +-
 lib/dump_stack.c       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 22c7052..e6131a78 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -200,7 +200,7 @@ static inline void show_regs_print_info(const char *log_lvl)
 }
 #endif
 
-extern void dump_stack(void) __cold;
+extern asmlinkage void dump_stack(void) __cold;
 
 #ifndef pr_fmt
 #define pr_fmt(fmt) fmt
diff --git a/lib/dump_stack.c b/lib/dump_stack.c
index c031541..f23b63f 100644
--- a/lib/dump_stack.c
+++ b/lib/dump_stack.c
@@ -23,7 +23,7 @@ static void __dump_stack(void)
 #ifdef CONFIG_SMP
 static atomic_t dump_lock = ATOMIC_INIT(-1);
 
-void dump_stack(void)
+asmlinkage void dump_stack(void)
 {
 	int was_locked;
 	int old;
@@ -55,7 +55,7 @@ retry:
 	preempt_enable();
 }
 #else
-void dump_stack(void)
+asmlinkage void dump_stack(void)
 {
 	__dump_stack();
 }
