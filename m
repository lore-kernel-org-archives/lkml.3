Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342Ab3KOEyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 23:54:36 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:35206 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758196Ab3KOEyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 23:54:14 -0500
X-AuditID: 85900ec0-d0927b9000001514-f1-5285a8ee1139
Subject: [PATCH -tip RFC v2 17/22] x86/kvm: Use NOKPROBE_SYMBOL macro in
 kvm.c
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Gleb Natapov <gleb@redhat.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 15 Nov 2013 04:54:05 +0000
Message-ID: <20131115045405.27580.16710.stgit@kbuild-fedora.novalocal>
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

Use NOKPROBE_SYMBOL macro for protecting functions
from kprobes instead of __kprobes annotation in kvm.c.
This also adds kvm_read_and_reset_pf_reason in
the blacklist because it can be called before
do_page_fault.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kernel/kvm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6dd802c..fb95987 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -251,8 +251,9 @@ u32 kvm_read_and_reset_pf_reason(void)
 	return reason;
 }
 EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
+NOKPROBE_SYMBOL(kvm_read_and_reset_pf_reason);
 
-dotraplinkage void __kprobes
+dotraplinkage void
 do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
@@ -276,6 +277,7 @@ do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 		break;
 	}
 }
+NOKPROBE_SYMBOL(do_async_page_fault);
 
 static void __init paravirt_ops_setup(void)
 {

