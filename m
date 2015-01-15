Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbbAOVWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:58307 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbAOVWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:37 -0500
Message-Id: <20150115211702.876012628@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 08/23] x86/x2apic: Clarify remapping mode for x2apic enablement
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-apic-clarify-remapping-mode.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the argument of try_to_enable_x2apic() so the purpose becomes
more clear.

Make the pr_warning more consistent and avoid the double print of
"disabling".

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1561,19 +1561,19 @@ void enable_x2apic(void)
 	}
 }
 
-static __init void try_to_enable_x2apic(int ir_stat)
+static __init void try_to_enable_x2apic(int remap_mode)
 {
 	if (!x2apic_supported())
 		return;
 
-	if (ir_stat != IRQ_REMAP_X2APIC_MODE) {
+	if (remap_mode != IRQ_REMAP_X2APIC_MODE) {
 		/* IR is required if there is APIC ID > 255 even when running
 		 * under KVM
 		 */
 		if (max_physical_apicid > 255 ||
 		    (IS_ENABLED(CONFIG_HYPERVISOR_GUEST) &&
 		     !hypervisor_x2apic_available())) {
-			pr_info("IRQ remapping doesn't support X2APIC mode, disable x2apic.\n");
+			pr_info("x2apic: IRQ remapping doesn't support X2APIC mode\n");
 			disable_x2apic();
 			return;
 		}
@@ -1609,7 +1609,7 @@ void __init check_x2apic(void)
 	 */
 	panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
 }
-static inline void try_to_enable_x2apic(int ir_stat) { }
+static inline void try_to_enable_x2apic(int remap_mode) { }
 #endif /* !CONFIG_X86_X2APIC */
 
 static int __init try_to_enable_IR(void)


