Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaGaRIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:08:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60814 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaGaRIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:08:36 -0400
Date: Thu, 31 Jul 2014 10:08:24 -0700
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-2f078b9cb8798cdabb7c2ff24b0b683eea546f96@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.02.1407302352320.17503@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407302352320.17503@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Remove enable_apic_mode callback
Git-Commit-ID: 2f078b9cb8798cdabb7c2ff24b0b683eea546f96
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

Commit-ID:  2f078b9cb8798cdabb7c2ff24b0b683eea546f96
Gitweb:     http://git.kernel.org/tip/2f078b9cb8798cdabb7c2ff24b0b683eea546f96
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 30 Jul 2014 23:53:51 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 31 Jul 2014 08:05:44 -0700

x86, apic: Remove enable_apic_mode callback

The enable_apic_mode() apic callback is never called, so remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1407302352320.17503@chino.kir.corp.google.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/apic.h           | 1 -
 arch/x86/kernel/apic/apic.c           | 2 --
 arch/x86/kernel/apic/apic_flat_64.c   | 2 --
 arch/x86/kernel/apic/apic_noop.c      | 1 -
 arch/x86/kernel/apic/apic_numachip.c  | 1 -
 arch/x86/kernel/apic/bigsmp_32.c      | 1 -
 arch/x86/kernel/apic/probe_32.c       | 1 -
 arch/x86/kernel/apic/x2apic_cluster.c | 1 -
 arch/x86/kernel/apic/x2apic_phys.c    | 1 -
 arch/x86/kernel/apic/x2apic_uv_x.c    | 1 -
 10 files changed, 12 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index e776ed2..c31fded 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -303,7 +303,6 @@ struct apic {
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	void (*apicid_to_cpu_present)(int phys_apicid, physid_mask_t *retmap);
 	int (*check_phys_apicid_present)(int phys_apicid);
-	void (*enable_apic_mode)(void);
 	int (*phys_pkg_id)(int cpuid_apic, int index_msb);
 
 	unsigned int (*get_apic_id)(unsigned long x);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d705bb7..6776027 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2042,8 +2042,6 @@ void __init connect_bsp_APIC(void)
 		imcr_pic_to_apic();
 	}
 #endif
-	if (apic->enable_apic_mode)
-		apic->enable_apic_mode();
 }
 
 /**
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 67d7a9d..de918c4 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -177,7 +177,6 @@ static struct apic apic_flat =  {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= flat_phys_pkg_id,
 
 	.get_apic_id			= flat_get_apic_id,
@@ -286,7 +285,6 @@ static struct apic apic_physflat =  {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= flat_phys_pkg_id,
 
 	.get_apic_id			= flat_get_apic_id,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index fe5d5e6..b205cdb 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -135,7 +135,6 @@ struct apic apic_noop = {
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 
 	.phys_pkg_id			= noop_phys_pkg_id,
 
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 6b55be3..ae91539 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -226,7 +226,6 @@ static const struct apic apic_numachip __refconst = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= numachip_phys_pkg_id,
 
 	.get_apic_id			= get_apic_id,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 349465a..c4a8d63 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -172,7 +172,6 @@ static struct apic apic_bigsmp = {
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= bigsmp_phys_pkg_id,
 
 	.get_apic_id			= bigsmp_get_apic_id,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 45ad6d8..bda4886 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -97,7 +97,6 @@ static struct apic apic_default = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= default_phys_pkg_id,
 
 	.get_apic_id			= default_get_apic_id,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index ac70128..6ce600f 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -258,7 +258,6 @@ static struct apic apic_x2apic_cluster = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= x2apic_phys_pkg_id,
 
 	.get_apic_id			= x2apic_get_apic_id,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 90eb77f..6fae733 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -112,7 +112,6 @@ static struct apic apic_x2apic_phys = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= x2apic_phys_pkg_id,
 
 	.get_apic_id			= x2apic_get_apic_id,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 480c05d..004f017 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -374,7 +374,6 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= uv_phys_pkg_id,
 
 	.get_apic_id			= x2apic_get_apic_id,
