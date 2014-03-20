Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbaCTXbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 19:31:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57198 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759458AbaCTXbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 19:31:01 -0400
Date: Thu, 20 Mar 2014 16:30:35 -0700
From: tip-bot for Dave Jones <tipbot@zytor.com>
Message-ID: <tip-8c90487cdc64847b4fdd812ab3047f426fec4d13@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davej@fedoraproject.org, davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davej@fedoraproject.org, tglx@linutronix.de, davej@redhat.com
In-Reply-To: <20140226154949.GA770@redhat.com>
References: <20140226154949.GA770@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] Rename TAINT_UNSAFE_SMP to TAINT_CPU_OUT_OF_SPEC
Git-Commit-ID: 8c90487cdc64847b4fdd812ab3047f426fec4d13
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

Commit-ID:  8c90487cdc64847b4fdd812ab3047f426fec4d13
Gitweb:     http://git.kernel.org/tip/8c90487cdc64847b4fdd812ab3047f426fec4d13
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Wed, 26 Feb 2014 10:49:49 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 20 Mar 2014 16:28:09 -0700

Rename TAINT_UNSAFE_SMP to TAINT_CPU_OUT_OF_SPEC

Rename TAINT_UNSAFE_SMP to TAINT_CPU_OUT_OF_SPEC, so we can repurpose
the flag to encompass a wider range of pushing the CPU beyond its
warrany.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Link: http://lkml.kernel.org/r/20140226154949.GA770@redhat.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/amd.c | 2 +-
 include/linux/kernel.h    | 2 +-
 kernel/module.c           | 2 +-
 kernel/panic.c            | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b85e43a..ce8b8ff 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -218,7 +218,7 @@ static void amd_k7_smp_check(struct cpuinfo_x86 *c)
 	 */
 	WARN_ONCE(1, "WARNING: This combination of AMD"
 		" processors is not suitable for SMP.\n");
-	add_taint(TAINT_UNSAFE_SMP, LOCKDEP_NOW_UNRELIABLE);
+	add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_NOW_UNRELIABLE);
 }
 
 static void init_amd_k7(struct cpuinfo_x86 *c)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 196d1ea..08fb024 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -458,7 +458,7 @@ extern enum system_states {
 
 #define TAINT_PROPRIETARY_MODULE	0
 #define TAINT_FORCED_MODULE		1
-#define TAINT_UNSAFE_SMP		2
+#define TAINT_CPU_OUT_OF_SPEC		2
 #define TAINT_FORCED_RMMOD		3
 #define TAINT_MACHINE_CHECK		4
 #define TAINT_BAD_PAGE			5
diff --git a/kernel/module.c b/kernel/module.c
index d24fcf2..ca2c1ad 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1015,7 +1015,7 @@ static size_t module_flags_taint(struct module *mod, char *buf)
 		buf[l++] = 'C';
 	/*
 	 * TAINT_FORCED_RMMOD: could be added.
-	 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
+	 * TAINT_CPU_OUT_OF_SPEC, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
 	 * apply to modules.
 	 */
 	return l;
diff --git a/kernel/panic.c b/kernel/panic.c
index 6d63003..2270cfd 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -199,7 +199,7 @@ struct tnt {
 static const struct tnt tnts[] = {
 	{ TAINT_PROPRIETARY_MODULE,	'P', 'G' },
 	{ TAINT_FORCED_MODULE,		'F', ' ' },
-	{ TAINT_UNSAFE_SMP,		'S', ' ' },
+	{ TAINT_CPU_OUT_OF_SPEC,	'S', ' ' },
 	{ TAINT_FORCED_RMMOD,		'R', ' ' },
 	{ TAINT_MACHINE_CHECK,		'M', ' ' },
 	{ TAINT_BAD_PAGE,		'B', ' ' },
