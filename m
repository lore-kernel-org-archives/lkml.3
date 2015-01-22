Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbbAVOZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:25:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57816 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbbAVOZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:25:25 -0500
Date: Thu, 22 Jan 2015 06:24:58 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-81a46dd8249d7fa72a8557e58a38aa984e6b5e16@git.kernel.org>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        tglx@linutronix.de, joro@8bytes.org, bp@alien8.de,
        jiang.liu@linux.intel.com, mingo@kernel.org
Reply-To: linux-kernel@vger.kernel.org, tony.luck@intel.com, joro@8bytes.org,
        tglx@linutronix.de, hpa@zytor.com, bp@alien8.de, mingo@kernel.org,
        jiang.liu@linux.intel.com
In-Reply-To: <20150115211702.363274310@linutronix.de>
References: <20150115211702.363274310@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic:
  Make x2apic_mode depend on CONFIG_X86_X2APIC
Git-Commit-ID: 81a46dd8249d7fa72a8557e58a38aa984e6b5e16
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

Commit-ID:  81a46dd8249d7fa72a8557e58a38aa984e6b5e16
Gitweb:     http://git.kernel.org/tip/81a46dd8249d7fa72a8557e58a38aa984e6b5e16
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:11 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:54 +0100

x86/apic: Make x2apic_mode depend on CONFIG_X86_X2APIC

No point in having a static variable around which is always 0. Let the
compiler optimize code out if disabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211702.363274310@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h | 8 ++++----
 arch/x86/kernel/apic/apic.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1a8ba26..d2225fd 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -106,8 +106,6 @@ extern u32 native_safe_apic_wait_icr_idle(void);
 extern void native_apic_icr_write(u32 low, u32 id);
 extern u64 native_apic_icr_read(void);
 
-extern int x2apic_mode;
-
 static inline bool apic_is_x2apic_enabled(void)
 {
 	u64 msr;
@@ -178,6 +176,7 @@ static inline u64 native_x2apic_icr_read(void)
 	return val;
 }
 
+extern int x2apic_mode;
 extern int x2apic_phys;
 extern int x2apic_preenabled;
 extern void check_x2apic(void);
@@ -210,8 +209,9 @@ static inline void x2apic_force_phys(void)
 {
 }
 
-#define	x2apic_preenabled 0
-#define	x2apic_supported()	0
+#define x2apic_mode		(0)
+#define	x2apic_preenabled	(0)
+#define	x2apic_supported()	(0)
 #endif
 
 extern void enable_IR_x2apic(void);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7ecfce1..a7d3b64 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -161,8 +161,8 @@ static __init int setup_apicpmtimer(char *s)
 __setup("apicpmtimer", setup_apicpmtimer);
 #endif
 
-int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
+int x2apic_mode;
 /* x2apic enabled before OS handover */
 int x2apic_preenabled;
 static int x2apic_disabled;
