Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab3KTEYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:24:44 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41198 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3KTEYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:24:12 -0500
Subject: [PATCH -tip v3 18/23] x86/dumpstack: Use NOKPROBE_SYMBOL macro in
 dumpstack.c
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Vineet Gupta <vgupta@synopsys.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 20 Nov 2013 04:22:33 +0000
Message-ID: <20131120042233.15296.31189.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL macro for protecting functions
from kprobes instead of __kprobes annotation in
dumpstack.c.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
---
 arch/x86/kernel/dumpstack.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index d9c12d3..b74ebc7 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -200,7 +200,7 @@ static arch_spinlock_t die_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 static int die_owner = -1;
 static unsigned int die_nest_count;
 
-unsigned __kprobes long oops_begin(void)
+unsigned long oops_begin(void)
 {
 	int cpu;
 	unsigned long flags;
@@ -223,8 +223,9 @@ unsigned __kprobes long oops_begin(void)
 	return flags;
 }
 EXPORT_SYMBOL_GPL(oops_begin);
+NOKPROBE_SYMBOL(oops_begin);
 
-void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
+void oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 {
 	if (regs && kexec_should_crash(current))
 		crash_kexec(regs);
@@ -247,8 +248,9 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
 		panic("Fatal exception");
 	do_exit(signr);
 }
+NOKPROBE_SYMBOL(oops_end);
 
-int __kprobes __die(const char *str, struct pt_regs *regs, long err)
+int __die(const char *str, struct pt_regs *regs, long err)
 {
 #ifdef CONFIG_X86_32
 	unsigned short ss;
@@ -291,6 +293,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 #endif
 	return 0;
 }
+NOKPROBE_SYMBOL(__die);
 
 /*
  * This is gone through when something in the kernel has done something bad


