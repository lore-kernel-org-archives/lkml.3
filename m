Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaGaRHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:07:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60732 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaGaRHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:07:15 -0400
Date: Thu, 31 Jul 2014 10:07:03 -0700
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-300eddf967920d35affa75db77c50c0fa493446a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.02.1407302349040.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302349040.17503@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic:
  Remove smp_callin_clear_local_apic callback
Git-Commit-ID: 300eddf967920d35affa75db77c50c0fa493446a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  300eddf967920d35affa75db77c50c0fa493446a
Gitweb:     http://git.kernel.org/tip/300eddf967920d35affa75db77c50c0fa493446a
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 30 Jul 2014 23:53:30 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 31 Jul 2014 08:05:41 -0700

x86, apic: Remove smp_callin_clear_local_apic callback

Since commit b5660ba76b41 ("x86, platforms: Remove NUMAQ") removed NUMAQ,
the smp_callin_clear_local_apic() apic callback has been obsolete.
Remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1407302349040.17503@chino.kir.corp.google.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/apic.h           | 1 -
 arch/x86/kernel/apic/apic_flat_64.c   | 2 --
 arch/x86/kernel/apic/apic_noop.c      | 1 -
 arch/x86/kernel/apic/apic_numachip.c  | 1 -
 arch/x86/kernel/apic/bigsmp_32.c      | 1 -
 arch/x86/kernel/apic/probe_32.c       | 1 -
 arch/x86/kernel/apic/x2apic_cluster.c | 1 -
 arch/x86/kernel/apic/x2apic_phys.c    | 1 -
 arch/x86/kernel/apic/x2apic_uv_x.c    | 1 -
 arch/x86/kernel/smpboot.c             | 4 ----
 10 files changed, 14 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 2201c26..b8c1380 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -336,7 +336,6 @@ struct apic {
 	int (*wakeup_secondary_cpu)(int apicid, unsigned long start_eip);
 
 	bool wait_for_init_deassert;
-	void (*smp_callin_clear_local_apic)(void);
 	void (*inquire_remote_apic)(int apicid);
 
 	/* apic ops */
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 7d56b65..a790497 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -197,7 +197,6 @@ static struct apic apic_flat =  {
 	.send_IPI_self			= apic_send_IPI_self,
 
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
@@ -311,7 +310,6 @@ static struct apic apic_physflat =  {
 	.send_IPI_self			= apic_send_IPI_self,
 
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index c638efa..f05b4f0 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -169,7 +169,6 @@ struct apic apic_noop = {
 	.wakeup_secondary_cpu		= noop_wakeup_secondary_cpu,
 
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
 	.read				= noop_apic_read,
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index c32f882..c0d9165 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -247,7 +247,6 @@ static const struct apic apic_numachip __refconst = {
 
 	.wakeup_secondary_cpu		= numachip_wakeup_secondary,
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL, /* REMRD not supported */
 
 	.read				= native_apic_mem_read,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 74ffd3e..eb15916 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -197,7 +197,6 @@ static struct apic apic_bigsmp = {
 	.send_IPI_self			= default_send_IPI_self,
 
 	.wait_for_init_deassert		= true,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 64248c7..5b617a9 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -117,7 +117,6 @@ static struct apic apic_default = {
 	.send_IPI_self			= default_send_IPI_self,
 
 	.wait_for_init_deassert		= true,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 8b3200c..d96cab1 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -278,7 +278,6 @@ static struct apic apic_x2apic_cluster = {
 	.send_IPI_self			= x2apic_send_IPI_self,
 
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
 	.read				= native_apic_msr_read,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 14c1891..73d0fee 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -132,7 +132,6 @@ static struct apic apic_x2apic_phys = {
 	.send_IPI_self			= x2apic_send_IPI_self,
 
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
 	.read				= native_apic_msr_read,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 58f0988..cc5d40e 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -395,7 +395,6 @@ static struct apic __refdata apic_x2apic_uv_x = {
 
 	.wakeup_secondary_cpu		= uv_wakeup_secondary,
 	.wait_for_init_deassert		= false,
-	.smp_callin_clear_local_apic	= NULL,
 	.inquire_remote_apic		= NULL,
 
 	.read				= native_apic_msr_read,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5492798..f0f3b19 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -168,10 +168,6 @@ static void smp_callin(void)
 	 * CPU, first the APIC. (this is probably redundant on most
 	 * boards)
 	 */
-
-	pr_debug("CALLIN, before setup_local_APIC()\n");
-	if (apic->smp_callin_clear_local_apic)
-		apic->smp_callin_clear_local_apic();
 	setup_local_APIC();
 	end_local_APIC_setup();
 
