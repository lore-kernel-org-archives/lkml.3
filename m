Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650Ab3DCI3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:29:22 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8726 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761522Ab3DCI3S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:29:18 -0400
From: <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <davem@davemloft.net>,
        <anil.s.keshavamurthy@intel.com>, <ananth@in.ibm.com>,
        <radovan.lekanovic@sonymobile.com>, <bjorn.davidsson@sonymobile.com>,
        <oskar.andero@sonymobile.com>
Subject: [PATCH 3/4] kprobes: move x86-specific blacklist symbols to arch directory
Date: Wed, 3 Apr 2013 10:28:53 +0200
Message-ID: <1364977734-32267-4-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com>
References: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Björn Davidsson <bjorn.davidsson@sonymobile.com>

The common kprobes blacklist contains x86-specific symbols.
Looking for these in kallsyms takes unnecessary time during startup
on non-X86 platform. The symbols where moved to
arch/x86/kernel/kprobes/core.c.

Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
Signed-off-by: Björn Davidsson <bjorn.davidsson@sonymobile.com>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 arch/x86/kernel/kprobes/core.c | 6 +++++-
 kernel/kprobes.c               | 3 ---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 4aa71a5..41ce6c1 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -65,7 +65,11 @@ void jprobe_return_end(void);
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
-const char * const arch_kprobes_blacksyms[] = {};
+const char * const arch_kprobes_blacksyms[] = {
+	"native_get_debugreg",
+	"irq_entries_start",
+	"common_interrupt",
+};
 const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
 
 #define stack_addr(regs) ((unsigned long *)kernel_stack_pointer(regs))
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 8a98ddb..3396eb8 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -95,9 +95,6 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
  */
 static const char * const common_kprobes_blacksyms[] = {
 	"preempt_schedule",
-	"native_get_debugreg",
-	"irq_entries_start",
-	"common_interrupt",
 	"mcount",       /* mcount can be called from everywhere */
 };
 static const size_t common_kprobes_blacksyms_size =
-- 
1.8.1.5

