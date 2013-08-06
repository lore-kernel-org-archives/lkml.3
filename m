Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab3HFVog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:44:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43541 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab3HFVoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:44:34 -0400
Date: Tue, 6 Aug 2013 14:44:22 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-9a55fdbe941e5cfb7a5c438db890a58dad82ef8e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1375740170-7446-13-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-13-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage, paravirt: Add __visible/
 asmlinkage to xen paravirt ops
Git-Commit-ID: 9a55fdbe941e5cfb7a5c438db890a58dad82ef8e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:44:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a55fdbe941e5cfb7a5c438db890a58dad82ef8e
Gitweb:     http://git.kernel.org/tip/9a55fdbe941e5cfb7a5c438db890a58dad82ef8e
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:46 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:20:56 -0700

x86, asmlinkage, paravirt: Add __visible/asmlinkage to xen paravirt ops

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-13-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/paravirt_types.h |  3 ++-
 arch/x86/kernel/paravirt.c            |  4 ++--
 arch/x86/xen/xen-ops.h                | 16 ++++++++--------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 0db1fca..0617ff2 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -387,7 +387,8 @@ extern struct pv_lock_ops pv_lock_ops;
 
 /* Simple instruction patching code. */
 #define DEF_NATIVE(ops, name, code) 					\
-	extern const char start_##ops##_##name[], end_##ops##_##name[];	\
+	extern const char start_##ops##_##name[] __visible,		\
+			  end_##ops##_##name[] __visible;		\
 	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
 
 unsigned paravirt_patch_nop(void);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index cd6de64..884aa40 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -324,7 +324,7 @@ struct pv_time_ops pv_time_ops = {
 	.steal_clock = native_steal_clock,
 };
 
-struct pv_irq_ops pv_irq_ops = {
+__visible struct pv_irq_ops pv_irq_ops = {
 	.save_fl = __PV_IS_CALLEE_SAVE(native_save_fl),
 	.restore_fl = __PV_IS_CALLEE_SAVE(native_restore_fl),
 	.irq_disable = __PV_IS_CALLEE_SAVE(native_irq_disable),
@@ -336,7 +336,7 @@ struct pv_irq_ops pv_irq_ops = {
 #endif
 };
 
-struct pv_cpu_ops pv_cpu_ops = {
+__visible struct pv_cpu_ops pv_cpu_ops = {
 	.cpuid = native_cpuid,
 	.get_debugreg = native_get_debugreg,
 	.set_debugreg = native_set_debugreg,
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 86782c5..d380213 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -105,9 +105,9 @@ static inline void __init xen_init_apic(void)
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
 #define DECL_ASM(ret, name, ...)		\
-	ret name(__VA_ARGS__);			\
-	extern char name##_end[];		\
-	extern char name##_reloc[]		\
+	asmlinkage ret name(__VA_ARGS__);	\
+	extern char name##_end[] __visible;	\
+	extern char name##_reloc[] __visible
 
 DECL_ASM(void, xen_irq_enable_direct, void);
 DECL_ASM(void, xen_irq_disable_direct, void);
@@ -115,11 +115,11 @@ DECL_ASM(unsigned long, xen_save_fl_direct, void);
 DECL_ASM(void, xen_restore_fl_direct, unsigned long);
 
 /* These are not functions, and cannot be called normally */
-void xen_iret(void);
-void xen_sysexit(void);
-void xen_sysret32(void);
-void xen_sysret64(void);
-void xen_adjust_exception_frame(void);
+asmlinkage void xen_iret(void);
+asmlinkage void xen_sysexit(void);
+asmlinkage void xen_sysret32(void);
+asmlinkage void xen_sysret64(void);
+asmlinkage void xen_adjust_exception_frame(void);
 
 extern int xen_panic_handler_init(void);
 
