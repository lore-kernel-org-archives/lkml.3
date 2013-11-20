Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3KTE1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:27:46 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40896 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3KTEWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:22:24 -0500
Subject: [PATCH -tip v3 12/23] x86/hw_breakpoint: Use NOKPROBE_SYMBOL macro
 in hw_breakpoint
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        Oleg Nesterov <oleg@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 20 Nov 2013 04:22:18 +0000
Message-ID: <20131120042218.15296.637.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL macro to protect functions from kprobes
instead of __kprobe annotation in hw_breakpoint.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/hw_breakpoint.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index f66ff16..cb4df84 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -425,7 +425,7 @@ EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
  * NOTIFY_STOP returned for all other cases
  *
  */
-static int __kprobes hw_breakpoint_handler(struct die_args *args)
+static int hw_breakpoint_handler(struct die_args *args)
 {
 	int i, cpu, rc = NOTIFY_STOP;
 	struct perf_event *bp;
@@ -508,11 +508,12 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 
 	return rc;
 }
+NOKPROBE_SYMBOL(hw_breakpoint_handler);
 
 /*
  * Handle debug exception notifications.
  */
-int __kprobes hw_breakpoint_exceptions_notify(
+int hw_breakpoint_exceptions_notify(
 		struct notifier_block *unused, unsigned long val, void *data)
 {
 	if (val != DIE_DEBUG)
@@ -520,6 +521,7 @@ int __kprobes hw_breakpoint_exceptions_notify(
 
 	return hw_breakpoint_handler(data);
 }
+NOKPROBE_SYMBOL(hw_breakpoint_exceptions_notify);
 
 void hw_breakpoint_pmu_read(struct perf_event *bp)
 {


