Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3LTXj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:39:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab3LTXjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:39:55 -0500
Date: Fri, 20 Dec 2013 15:39:33 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-9d69bb2cd96221b35bcabb3c1ffe84160bcf1b9f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, prarit@redhat.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, prarit@redhat.com
In-Reply-To: <1387554609-9823-1-git-send-email-prarit@redhat.com>
References: <1387554609-9823-1-git-send-email-prarit@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, irq: Change check_vectors()
  to check_irq_vectors_for_cpu_disable()
Git-Commit-ID: 9d69bb2cd96221b35bcabb3c1ffe84160bcf1b9f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 20 Dec 2013 15:39:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d69bb2cd96221b35bcabb3c1ffe84160bcf1b9f
Gitweb:     http://git.kernel.org/tip/9d69bb2cd96221b35bcabb3c1ffe84160bcf1b9f
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 20 Dec 2013 15:34:22 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 20 Dec 2013 15:34:22 -0800

x86, irq: Change check_vectors() to check_irq_vectors_for_cpu_disable()

In the context of smpboot.c especially, it is not at all obvious what
"check_vectors" actually mean.  Since this function is only called in
one place, without arguments, we can afford to be a bit more verbose
with the function name and make it clear at a glance what the function
does.

Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1387554609-9823-1-git-send-email-prarit@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/irq.h | 2 +-
 arch/x86/kernel/irq.c      | 2 +-
 arch/x86/kernel/smpboot.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index dfd7372..cb6cfcd 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -25,7 +25,7 @@ extern void irq_ctx_init(int cpu);
 
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
-extern int check_vectors(void);
+extern int check_irq_vectors_for_cpu_disable(void);
 extern void fixup_irqs(void);
 extern void irq_force_complete_move(int);
 #endif
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 483f111..7d40698 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -266,7 +266,7 @@ EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
  * This cpu is going to be removed and its vectors migrated to the remaining
  * online cpus.  Check to see if there are enough vectors in the remaining cpus.
  */
-int check_vectors(void)
+int check_irq_vectors_for_cpu_disable(void)
 {
 	int irq, cpu;
 	unsigned int vector, this_count, count;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7ac6654..391ea52 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1314,7 +1314,7 @@ int native_cpu_disable(void)
 {
 	int ret;
 
-	ret = check_vectors();
+	ret = check_irq_vectors_for_cpu_disable();
 	if (ret)
 		return ret;
 
