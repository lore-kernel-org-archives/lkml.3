Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaGaRIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:08:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbaGaRIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:08:21 -0400
Date: Thu, 31 Jul 2014 10:08:09 -0700
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-11a8318ef5a69cdb9be61f726d6e078d70af6129@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.02.1407302351480.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302351480.17503@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Remove setup_portio_remap callback
Git-Commit-ID: 11a8318ef5a69cdb9be61f726d6e078d70af6129
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

Commit-ID:  11a8318ef5a69cdb9be61f726d6e078d70af6129
Gitweb:     http://git.kernel.org/tip/11a8318ef5a69cdb9be61f726d6e078d70af6129
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 30 Jul 2014 23:53:47 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 31 Jul 2014 08:05:44 -0700

x86, apic: Remove setup_portio_remap callback

Since commit b5660ba76b41 ("x86, platforms: Remove NUMAQ") removed NUMAQ,
the setup_portio_remap() apic callback has been obsolete.  Remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1407302351480.17503@chino.kir.corp.google.com
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
index d8da5fc..e776ed2 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -302,7 +302,6 @@ struct apic {
 	void (*setup_apic_routing)(void);
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
-	void (*setup_portio_remap)(void);
 	int (*check_phys_apicid_present)(int phys_apicid);
 	void (*enable_apic_mode)(void);
 	int (*phys_pkg_id)(int cpuid_apic, int index_msb);
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index f23b5e8..67d7a9d 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -176,7 +176,6 @@ static struct apic apic_flat =  {
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= flat_phys_pkg_id,
@@ -286,7 +285,6 @@ static struct apic apic_physflat =  {
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= flat_phys_pkg_id,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 66a91e5..fe5d5e6 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -134,7 +134,6 @@ struct apic apic_noop = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 3d7f6b2..6b55be3 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -225,7 +225,6 @@ static const struct apic apic_numachip __refconst = {
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= numachip_phys_pkg_id,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index fa99280..349465a 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -171,7 +171,6 @@ static struct apic apic_bigsmp = {
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= bigsmp_phys_pkg_id,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index a445842..45ad6d8 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -96,7 +96,6 @@ static struct apic apic_default = {
 	.setup_apic_routing		= setup_apic_flat_routing,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= default_phys_pkg_id,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 88eeaa9..ac70128 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -257,7 +257,6 @@ static struct apic apic_x2apic_cluster = {
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= x2apic_phys_pkg_id,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 29614ae..90eb77f 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -111,7 +111,6 @@ static struct apic apic_x2apic_phys = {
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= x2apic_phys_pkg_id,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 5376012..480c05d 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -373,7 +373,6 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
-	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= uv_phys_pkg_id,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f0f3b19..2d872e0 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1139,10 +1139,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		enable_IO_APIC();
 
 	bsp_end_local_APIC_setup();
-
-	if (apic->setup_portio_remap)
-		apic->setup_portio_remap();
-
 	smpboot_setup_io_apic();
 	/*
 	 * Set up local APIC timer on boot CPU.
