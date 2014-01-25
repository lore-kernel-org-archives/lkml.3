Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaAYOYn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:24:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52476 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaAYOYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:24:39 -0500
Date: Sat, 25 Jan 2014 06:24:16 -0800
From: tip-bot for Mike Travis <tipbot@zytor.com>
Message-ID: <tip-74c93f9d39b556ff9ac2340d568ad5caf8446c65@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        travis@sgi.com, acme@ghostprotocols.net, hedi@sgi.com, rja@sgi.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, travis@sgi.com,
        jason.wessel@windriver.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hedi@sgi.com, rja@sgi.com, tglx@linutronix.de
In-Reply-To: <20140114162551.480872353@asylum.americas.sgi.com>
References: <20140114162551.480872353@asylum.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] x86/uv/nmi: Fix Sparse warnings
Git-Commit-ID: 74c93f9d39b556ff9ac2340d568ad5caf8446c65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:24:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74c93f9d39b556ff9ac2340d568ad5caf8446c65
Gitweb:     http://git.kernel.org/tip/74c93f9d39b556ff9ac2340d568ad5caf8446c65
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Tue, 14 Jan 2014 10:25:53 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 08:55:10 +0100

x86/uv/nmi: Fix Sparse warnings

Make uv_register_nmi_notifier() and uv_handle_nmi_ping() static
to address sparse warnings.

Fix problem where uv_nmi_kexec_failed is unused when
CONFIG_KEXEC is not defined.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Hedi Berriche <hedi@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/20140114162551.480872353@asylum.americas.sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/uv/uv.h       | 2 --
 arch/x86/kernel/apic/x2apic_uv_x.c | 1 -
 arch/x86/platform/uv/uv_nmi.c      | 9 ++++-----
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv.h b/arch/x86/include/asm/uv/uv.h
index 6b964a0..062921e 100644
--- a/arch/x86/include/asm/uv/uv.h
+++ b/arch/x86/include/asm/uv/uv.h
@@ -12,7 +12,6 @@ extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 extern void uv_cpu_init(void);
 extern void uv_nmi_init(void);
-extern void uv_register_nmi_notifier(void);
 extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
@@ -26,7 +25,6 @@ static inline enum uv_system_type get_uv_system_type(void) { return UV_NONE; }
 static inline int is_uv_system(void)	{ return 0; }
 static inline void uv_cpu_init(void)	{ }
 static inline void uv_system_init(void)	{ }
-static inline void uv_register_nmi_notifier(void) { }
 static inline const struct cpumask *
 uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
 		    unsigned long start, unsigned long end, unsigned int cpu)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index ad0dc04..d263b13 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -980,7 +980,6 @@ void __init uv_system_init(void)
 	uv_nmi_setup();
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
-	uv_register_nmi_notifier();
 	proc_mkdir("sgi_uv", NULL);
 
 	/* register Legacy VGA I/O redirection handler */
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index 7486c21..3a3c425 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -74,7 +74,6 @@ static atomic_t	uv_in_nmi;
 static atomic_t uv_nmi_cpu = ATOMIC_INIT(-1);
 static atomic_t uv_nmi_cpus_in_nmi = ATOMIC_INIT(-1);
 static atomic_t uv_nmi_slave_continue;
-static atomic_t uv_nmi_kexec_failed;
 static cpumask_var_t uv_nmi_cpu_mask;
 
 /* Values for uv_nmi_slave_continue */
@@ -504,6 +503,7 @@ static void uv_nmi_touch_watchdogs(void)
 }
 
 #if defined(CONFIG_KEXEC)
+static atomic_t uv_nmi_kexec_failed;
 static void uv_nmi_kdump(int cpu, int master, struct pt_regs *regs)
 {
 	/* Call crash to dump system state */
@@ -634,7 +634,7 @@ int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
 /*
  * NMI handler for pulling in CPUs when perf events are grabbing our NMI
  */
-int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
+static int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
 {
 	int ret;
 
@@ -651,7 +651,7 @@ int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
 	return ret;
 }
 
-void uv_register_nmi_notifier(void)
+static void uv_register_nmi_notifier(void)
 {
 	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
 		pr_warn("UV: NMI handler failed to register\n");
@@ -695,6 +695,5 @@ void uv_nmi_setup(void)
 		uv_hub_nmi_per(cpu) = uv_hub_nmi_list[nid];
 	}
 	BUG_ON(!alloc_cpumask_var(&uv_nmi_cpu_mask, GFP_KERNEL));
+	uv_register_nmi_notifier();
 }
-
-
