Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab3KOEyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:54:41 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57612 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758150Ab3KOExz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:53:55 -0500
X-AuditID: 85900ec0-d1d29b9000001514-ec-5285a8e05e55
Subject: [PATCH -tip RFC v2 12/22] x86/hw_breakpoint: Use NOKPROBE_SYMBOL
 macro in hw_breakpoint
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        x86@kernel.org, Oleg Nesterov <oleg@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 15 Nov 2013 04:53:50 +0000
Message-ID: <20131115045350.27580.76405.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
References: <20131115045312.27580.95902.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
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

