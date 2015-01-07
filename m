Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbbAGH3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:29:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:12336 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbbAGH3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:29:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,713,1413270000"; 
   d="scan'208";a="665633691"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Joerg Roedel <joro@8bytes.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Beulich <JBeulich@suse.com>, Richard Weinberger <richard@nod.at>,
        Oren Twaig <oren@scalemp.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: [Patch v2 05/16] x86/apic: Kill useless variable x2apic_enabled in function enable_IR_x2apic()
Date: Wed,  7 Jan 2015 15:31:32 +0800
Message-Id: <1420615903-28253-6-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
References: <1420615903-28253-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local variable x2apic_enabled has been assigned to but never referred,
so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/apic.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 8b58e23bc5e8..a614e242473b 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1594,7 +1594,7 @@ int __init enable_IR(void)
 void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
-	int ret, x2apic_enabled = 0;
+	int ret;
 	int hardware_init_ret;
 
 	if (!IS_ENABLED(CONFIG_X86_X2APIC)) {
@@ -1652,8 +1652,6 @@ void __init enable_IR_x2apic(void)
 		goto skip_x2apic;
 	}
 
-	x2apic_enabled = 1;
-
 	if (x2apic_supported() && !x2apic_mode) {
 		x2apic_mode = 1;
 		enable_x2apic();
-- 
1.7.10.4

