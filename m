Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaBJNb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:31:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaBJNbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:31:24 -0500
Date: Mon, 10 Feb 2014 05:31:13 -0800
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-d3c63ae1e2e35e4250390c079dc3fb7291347f5c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Only use default_wait_for_init_deassert(
 )
Git-Commit-ID: d3c63ae1e2e35e4250390c079dc3fb7291347f5c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:31:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3c63ae1e2e35e4250390c079dc3fb7291347f5c
Gitweb:     http://git.kernel.org/tip/d3c63ae1e2e35e4250390c079dc3fb7291347f5c
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Tue, 4 Feb 2014 23:54:58 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 15:15:07 +0100

x86/apic: Only use default_wait_for_init_deassert()

es7000_wait_for_init_deassert() is functionally equivalent to
default_wait_for_init_deassert(), so remove the duplicate code
and use only a single function.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1402042353030.7839@chino.kir.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h      | 1 -
 arch/x86/kernel/apic/es7000_32.c | 8 +-------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1d2091a..2ef7013 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -521,7 +521,6 @@ static inline void default_wait_for_init_deassert(atomic_t *deassert)
 {
 	while (!atomic_read(deassert))
 		cpu_relax();
-	return;
 }
 
 extern void generic_bigsmp_probe(void);
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index c552247..d03d57e 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -394,12 +394,6 @@ static void es7000_enable_apic_mode(void)
 		WARN(1, "Command failed, status = %x\n", mip_status);
 }
 
-static void es7000_wait_for_init_deassert(atomic_t *deassert)
-{
-	while (!atomic_read(deassert))
-		cpu_relax();
-}
-
 static unsigned int es7000_get_apic_id(unsigned long x)
 {
 	return (x >> 24) & 0xFF;
@@ -722,7 +716,7 @@ static struct apic __refdata apic_es7000 = {
 	.trampoline_phys_low		= 0x467,
 	.trampoline_phys_high		= 0x469,
 
-	.wait_for_init_deassert		= es7000_wait_for_init_deassert,
+	.wait_for_init_deassert		= default_wait_for_init_deassert,
 
 	/* Nothing to do for most platforms, since cleared by the INIT cycle: */
 	.smp_callin_clear_local_apic	= NULL,
