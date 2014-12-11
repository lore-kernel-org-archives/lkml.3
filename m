Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbaLKSHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:07:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758573AbaLKSGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:06:51 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 3/4] xen: use generated hypervisor symbols in arch/x86/xen/trace.c
Date: Thu, 11 Dec 2014 19:04:24 +0100
Message-Id: <1418321065-10212-4-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1418321065-10212-1-git-send-email-jgross@suse.com>
References: <1418321065-10212-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of manually list all hypervisor calls in arch/x86/xen/trace.c
use the auto generated list.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/trace.c | 50 ++++----------------------------------------------
 1 file changed, 4 insertions(+), 46 deletions(-)

diff --git a/arch/x86/xen/trace.c b/arch/x86/xen/trace.c
index 8296cdf..a702ec2 100644
--- a/arch/x86/xen/trace.c
+++ b/arch/x86/xen/trace.c
@@ -1,54 +1,12 @@
 #include <linux/ftrace.h>
 #include <xen/interface/xen.h>
+#include <xen/interface/xen-mca.h>
 
-#define N(x)	[__HYPERVISOR_##x] = "("#x")"
+#define HYPERCALL(x)	[__HYPERVISOR_##x] = "("#x")",
 static const char *xen_hypercall_names[] = {
-	N(set_trap_table),
-	N(mmu_update),
-	N(set_gdt),
-	N(stack_switch),
-	N(set_callbacks),
-	N(fpu_taskswitch),
-	N(sched_op_compat),
-	N(dom0_op),
-	N(set_debugreg),
-	N(get_debugreg),
-	N(update_descriptor),
-	N(memory_op),
-	N(multicall),
-	N(update_va_mapping),
-	N(set_timer_op),
-	N(event_channel_op_compat),
-	N(xen_version),
-	N(console_io),
-	N(physdev_op_compat),
-	N(grant_table_op),
-	N(vm_assist),
-	N(update_va_mapping_otherdomain),
-	N(iret),
-	N(vcpu_op),
-	N(set_segment_base),
-	N(mmuext_op),
-	N(xsm_op),
-	N(nmi_op),
-	N(sched_op),
-	N(callback_op),
-	N(xenoprof_op),
-	N(event_channel_op),
-	N(physdev_op),
-	N(hvm_op),
-
-/* Architecture-specific hypercall definitions. */
-	N(arch_0),
-	N(arch_1),
-	N(arch_2),
-	N(arch_3),
-	N(arch_4),
-	N(arch_5),
-	N(arch_6),
-	N(arch_7),
+#include <asm/xen-hypercalls.h>
 };
-#undef N
+#undef HYPERCALL
 
 static const char *xen_hypercall_name(unsigned op)
 {
-- 
2.1.2

