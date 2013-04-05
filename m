Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161548Ab3DEN1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:27:40 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6201 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161369Ab3DEN1P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:27:15 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        <davem@davemloft.net>, <anil.s.keshavamurthy@intel.com>,
        <ananth@in.ibm.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        <radovan.lekanovic@sonymobile.com>, <bjorn.davidsson@sonymobile.com>,
        <oskar.andero@sonymobile.com>
Subject: [PATCH v3 3/4] kprobes: move x86-specific blacklist symbols to arch directory
Date: Fri, 5 Apr 2013 15:26:39 +0200
Message-ID: <1365168400-17954-4-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365168400-17954-1-git-send-email-oskar.andero@sonymobile.com>
References: <1365168400-17954-1-git-send-email-oskar.andero@sonymobile.com>
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

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: linux-arch@vger.kernel.org
Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
Signed-off-by: Björn Davidsson <bjorn.davidsson@sonymobile.com>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/x86/kernel/kprobes/core.c | 7 +++++++
 kernel/kprobes.c               | 3 ---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 7bfe318..41ce6c1 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -65,6 +65,13 @@ void jprobe_return_end(void);
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
+const char * const arch_kprobes_blacksyms[] = {
+	"native_get_debugreg",
+	"irq_entries_start",
+	"common_interrupt",
+};
+const size_t arch_kprobes_blacksyms_size = ARRAY_SIZE(arch_kprobes_blacksyms);
+
 #define stack_addr(regs) ((unsigned long *)kernel_stack_pointer(regs))
 
 #define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 2458ae1..b289384 100644
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

