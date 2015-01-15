Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbbAOVWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:58250 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbbAOVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:27 -0500
Message-Id: <20150115211702.363274310@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 02/23] x86/apic: Make x2apic_mode depend on CONFIG_X86_X2APIC
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=x86-apic-make-x2apic-mode-depend-on-config.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point in having a static variable around which is always 0. Let the
compiler optimize code out if disabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h |    8 ++++----
 arch/x86/kernel/apic/apic.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -106,8 +106,6 @@ extern u32 native_safe_apic_wait_icr_idl
 extern void native_apic_icr_write(u32 low, u32 id);
 extern u64 native_apic_icr_read(void);
 
-extern int x2apic_mode;
-
 static inline bool apic_is_x2apic_enabled(void)
 {
 	u64 msr;
@@ -177,6 +175,7 @@ static inline u64 native_x2apic_icr_read
 	return val;
 }
 
+extern int x2apic_mode;
 extern int x2apic_phys;
 extern int x2apic_preenabled;
 extern void check_x2apic(void);
@@ -209,8 +208,9 @@ static inline void x2apic_force_phys(voi
 {
 }
 
-#define	x2apic_preenabled 0
-#define	x2apic_supported()	0
+#define x2apic_mode		(0)
+#define	x2apic_preenabled	(0)
+#define	x2apic_supported()	(0)
 #endif
 
 extern void enable_IR_x2apic(void);
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -161,8 +161,8 @@ static __init int setup_apicpmtimer(char
 __setup("apicpmtimer", setup_apicpmtimer);
 #endif
 
-int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
+int x2apic_mode;
 /* x2apic enabled before OS handover */
 int x2apic_preenabled;
 static int x2apic_disabled;


