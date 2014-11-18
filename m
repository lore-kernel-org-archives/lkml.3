Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaKRAG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:06:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48996 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaKRAGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:06:25 -0500
Date: Mon, 17 Nov 2014 16:06:14 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-95290cf13e561b52dceadb9a8b8ee8ff2464b142@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        qiaowei.ren@intel.com, mingo@kernel.org, tglx@linutronix.de,
        dave@sr71.net
Reply-To: dave.hansen@linux.intel.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, dave@sr71.net
In-Reply-To: <20141114151823.B358EAD2@viggo.jf.intel.com>
References: <20141114151823.B358EAD2@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86, mpx: Add MPX to disabled features
Git-Commit-ID: 95290cf13e561b52dceadb9a8b8ee8ff2464b142
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

Commit-ID:  95290cf13e561b52dceadb9a8b8ee8ff2464b142
Gitweb:     http://git.kernel.org/tip/95290cf13e561b52dceadb9a8b8ee8ff2464b142
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Fri, 14 Nov 2014 07:18:23 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 18 Nov 2014 00:58:53 +0100

x86, mpx: Add MPX to disabled features

This allows us to use cpu_feature_enabled(X86_FEATURE_MPX) as
both a runtime and compile-time check.

When CONFIG_X86_INTEL_MPX is disabled,
cpu_feature_enabled(X86_FEATURE_MPX) will evaluate at
compile-time to 0. If CONFIG_X86_INTEL_MPX=y, then the cpuid
flag will be checked at runtime.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: linux-mm@kvack.org
Cc: linux-mips@linux-mips.org
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20141114151823.B358EAD2@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/disabled-features.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 97534a7..f226df0 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -10,6 +10,12 @@
  * cpu_feature_enabled().
  */
 
+#ifdef CONFIG_X86_INTEL_MPX
+# define DISABLE_MPX	0
+#else
+# define DISABLE_MPX	(1<<(X86_FEATURE_MPX & 31))
+#endif
+
 #ifdef CONFIG_X86_64
 # define DISABLE_VME		(1<<(X86_FEATURE_VME & 31))
 # define DISABLE_K6_MTRR	(1<<(X86_FEATURE_K6_MTRR & 31))
@@ -34,6 +40,6 @@
 #define DISABLED_MASK6	0
 #define DISABLED_MASK7	0
 #define DISABLED_MASK8	0
-#define DISABLED_MASK9	0
+#define DISABLED_MASK9	(DISABLE_MPX)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
