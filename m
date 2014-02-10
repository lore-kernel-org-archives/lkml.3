Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaBJNcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:32:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33238 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaBJNb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:31:58 -0500
Date: Mon, 10 Feb 2014 05:31:46 -0800
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-dc9788f40a769d967de3eb5a7aee8c1a70094d32@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.02.1402042354380.7839@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1402042354380.7839@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Always define nox2apic and define it as initdata
Git-Commit-ID: dc9788f40a769d967de3eb5a7aee8c1a70094d32
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:31:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc9788f40a769d967de3eb5a7aee8c1a70094d32
Gitweb:     http://git.kernel.org/tip/dc9788f40a769d967de3eb5a7aee8c1a70094d32
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Tue, 4 Feb 2014 23:55:06 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 15:15:11 +0100

x86/apic: Always define nox2apic and define it as initdata

The "nox2apic" variable can be defined as __initdata since it is
only used for bootstrap.  It can now unconditionally be defined
since it will later be freed.

At the same time, it is also better off as a bool.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1402042354380.7839@chino.kir.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/apic.h | 1 -
 arch/x86/kernel/apic/apic.c | 9 ++++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b4c561d..19b0eba 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -217,7 +217,6 @@ static inline void x2apic_force_phys(void)
 {
 }
 
-#define	nox2apic	0
 #define	x2apic_preenabled 0
 #define	x2apic_supported()	0
 #endif
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7f26c9a..f824d69 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -133,6 +133,10 @@ static inline void imcr_apic_to_pic(void)
  * +1=force-enable
  */
 static int force_enable_local_apic __initdata;
+
+/* Control whether x2APIC mode is enabled or not */
+static bool nox2apic __initdata;
+
 /*
  * APIC command line parameters
  */
@@ -162,8 +166,7 @@ int x2apic_mode;
 /* x2apic enabled before OS handover */
 int x2apic_preenabled;
 static int x2apic_disabled;
-static int nox2apic;
-static __init int setup_nox2apic(char *str)
+static int __init setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
 		int apicid = native_apic_msr_read(APIC_ID);
@@ -178,7 +181,7 @@ static __init int setup_nox2apic(char *str)
 	} else
 		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 
-	nox2apic = 1;
+	nox2apic = true;
 
 	return 0;
 }
