Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbbAVO10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:27:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57887 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbAVO1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:27:23 -0500
Date: Thu, 22 Jan 2015 06:26:59 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-62e61633daeb0b53f0506aa6e170e2e4cc75cd65@git.kernel.org>
Cc: joro@8bytes.org, bp@alien8.de, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jiang.liu@linux.intel.com, tony.luck@intel.com
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, joro@8bytes.org, bp@alien8.de,
        jiang.liu@linux.intel.com, tony.luck@intel.com
In-Reply-To: <20150115211702.876012628@linutronix.de>
References: <20150115211702.876012628@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/x2apic:
  Clarify remapping mode for x2apic enablement
Git-Commit-ID: 62e61633daeb0b53f0506aa6e170e2e4cc75cd65
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

Commit-ID:  62e61633daeb0b53f0506aa6e170e2e4cc75cd65
Gitweb:     http://git.kernel.org/tip/62e61633daeb0b53f0506aa6e170e2e4cc75cd65
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:21 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:55 +0100

x86/x2apic: Clarify remapping mode for x2apic enablement

Rename the argument of try_to_enable_x2apic() so the purpose becomes
more clear.

Make the pr_warning more consistent and avoid the double print of
"disabling".

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20150115211702.876012628@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index bda56ee..06b7521 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
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
@@ -1611,7 +1611,7 @@ static int __init validate_x2apic(void)
 }
 early_initcall(validate_x2apic);
 
-static inline void try_to_enable_x2apic(int ir_stat) { }
+static inline void try_to_enable_x2apic(int remap_mode) { }
 #endif /* !CONFIG_X86_X2APIC */
 
 static int __init try_to_enable_IR(void)
