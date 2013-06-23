Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab3FWLBz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 07:01:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3FWLBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 07:01:51 -0400
Date: Sun, 23 Jun 2013 04:01:25 -0700
From: tip-bot for Seiji Aguchi <tipbot@zytor.com>
Message-ID: <tip-33e5ff634f07dec26b7ed1fd7f9e32978fe1f2b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        seiji.aguchi@hds.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seiji.aguchi@hds.com, tglx@linutronix.de
In-Reply-To: <51C58B8A.2080808@hds.com>
References: <51C58B8A.2080808@hds.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trace] x86/tracing:
  Add config option checking to the definitions of mce handlers
Git-Commit-ID: 33e5ff634f07dec26b7ed1fd7f9e32978fe1f2b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 23 Jun 2013 04:01:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33e5ff634f07dec26b7ed1fd7f9e32978fe1f2b2
Gitweb:     http://git.kernel.org/tip/33e5ff634f07dec26b7ed1fd7f9e32978fe1f2b2
Author:     Seiji Aguchi <seiji.aguchi@hds.com>
AuthorDate: Sat, 22 Jun 2013 07:33:30 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 23 Jun 2013 11:41:36 +0200

x86/tracing: Add config option checking to the definitions of mce handlers

In case CONFIG_X86_MCE_THRESHOLD and CONFIG_X86_THERMAL_VECTOR
are disabled, kernel build fails as follows.

   arch/x86/built-in.o: In function `trace_threshold_interrupt':
   (.entry.text+0x122b): undefined reference to `smp_trace_threshold_interrupt'
   arch/x86/built-in.o: In function `trace_thermal_interrupt':
   (.entry.text+0x132b): undefined reference to `smp_trace_thermal_interrupt'

In this case, trace_threshold_interrupt/trace_thermal_interrupt
are not needed to define.

So, add config option checking to their definitions in entry_64.S.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: rostedt@goodmis.org
Link: http://lkml.kernel.org/r/51C58B8A.2080808@hds.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/entry_64.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 11eef43..53d6398 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1188,10 +1188,15 @@ apicinterrupt3 POSTED_INTR_VECTOR \
 	kvm_posted_intr_ipi smp_kvm_posted_intr_ipi
 #endif
 
+#ifdef CONFIG_X86_MCE_THRESHOLD
 apicinterrupt THRESHOLD_APIC_VECTOR \
 	threshold_interrupt smp_threshold_interrupt
+#endif
+
+#ifdef CONFIG_X86_THERMAL_VECTOR
 apicinterrupt THERMAL_APIC_VECTOR \
 	thermal_interrupt smp_thermal_interrupt
+#endif
 
 #ifdef CONFIG_SMP
 apicinterrupt CALL_FUNCTION_SINGLE_VECTOR \
