Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaJSJux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 05:50:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59957 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaJSJut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 05:50:49 -0400
Date: Sun, 19 Oct 2014 02:49:21 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-db6a00b4bed3abbb038077ba4fdc5be481fe5559@git.kernel.org>
Cc: prarit@redhat.com, mingo@kernel.org, tianyu.lan@intel.com,
        peterz@infradead.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, bp@suse.de, tglx@linutronix.de,
        hpa@zytor.com
Reply-To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        hpa@zytor.com, tglx@linutronix.de, bp@suse.de, tianyu.lan@intel.com,
        prarit@redhat.com, mingo@kernel.org, peterz@infradead.org
In-Reply-To: <1409039025-32310-1-git-send-email-tianyu.lan@intel.com>
References: <1409039025-32310-1-git-send-email-tianyu.lan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/smpboot:
  Move data structure to its primary usage scope
Git-Commit-ID: db6a00b4bed3abbb038077ba4fdc5be481fe5559
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

Commit-ID:  db6a00b4bed3abbb038077ba4fdc5be481fe5559
Gitweb:     http://git.kernel.org/tip/db6a00b4bed3abbb038077ba4fdc5be481fe5559
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sun, 19 Oct 2014 11:41:52 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 19 Oct 2014 11:44:49 +0200

x86/smpboot: Move data structure to its primary usage scope

Makes the code more readable by moving variable and usage closer
to each other, which also avoids this build warning in the
!CONFIG_HOTPLUG_CPU case:

  arch/x86/kernel/smpboot.c:105:42: warning: ‘die_complete’ defined but not used [-Wunused-variable]

Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Lan Tianyu <tianyu.lan@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: srostedt@redhat.com
Cc: toshi.kani@hp.com
Cc: imammedo@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1409039025-32310-1-git-send-email-tianyu.lan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smpboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2d5200e..4d2128a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -102,8 +102,6 @@ DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
-static DEFINE_PER_CPU(struct completion, die_complete);
-
 atomic_t init_deasserted;
 
 /*
@@ -1318,6 +1316,8 @@ void cpu_disable_common(void)
 	fixup_irqs();
 }
 
+static DEFINE_PER_CPU(struct completion, die_complete);
+
 int native_cpu_disable(void)
 {
 	int ret;
