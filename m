Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbaLJGpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:45:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:60519 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614AbaLJGpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:45:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,550,1413270000"; 
   d="scan'208";a="645283026"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Beulich <JBeulich@suse.com>, Richard Weinberger <richard@nod.at>,
        Oren Twaig <oren@scalemp.com>
Cc: Tony Luck <tony.luck@intel.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC Patch V1 1/9] x86, apic: Kill useless variable x2apic_enabled in function enable_IR_x2apic()
Date: Wed, 10 Dec 2014 14:47:43 +0800
Message-Id: <1418194071-13785-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
References: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
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
index 141f1031013d..e7a426a589df 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1594,7 +1594,7 @@ int __init enable_IR(void)
 void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
-	int ret, x2apic_enabled = 0;
+	int ret;
 	int hardware_init_ret;
 
 	hardware_init_ret = irq_remapping_prepare();
@@ -1644,8 +1644,6 @@ void __init enable_IR_x2apic(void)
 		goto skip_x2apic;
 	}
 
-	x2apic_enabled = 1;
-
 	if (x2apic_supported() && !x2apic_mode) {
 		x2apic_mode = 1;
 		enable_x2apic();
-- 
1.7.10.4

