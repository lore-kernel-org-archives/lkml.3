Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbaHYXKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 19:10:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:50612 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755138AbaHYXKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 19:10:37 -0400
Date: Mon, 25 Aug 2014 19:10:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Davis <jim.epost@gmail.com>,
        linux-next <linux-next@vger.kernel.org>
Subject: [PATCH] KVM: Only export kvm_ple_window for x86_64
Message-ID: <20140825191035.59673878@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 7b46268d2954 "KVM: trace kvm_ple_window grow/shrink"
Added the tracepoint kvm_ple_window under a #ifdef CONFIG_X86_64 but
left the export for that tracepoint unprotected, which would cause it
to fail to compile when X86_32 is set.

Link: http://lkml.kernel.org/p/20140825172204.769ab4e6@gandalf.local.home

Reported-by: Jim Davis <jim.epost@gmail.com>
tested-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c10408ef9ab1..3da45a3ecaa4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7673,4 +7673,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);
+#ifdef CONFIG_X86_64
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window);
+#endif
-- 
1.8.1.4

