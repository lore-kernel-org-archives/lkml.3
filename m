Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbaLJGr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:47:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:60519 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620AbaLJGpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:45:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,550,1413270000"; 
   d="scan'208";a="645283154"
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
Subject: [RFC Patch V1 2/9] x86, apic: Correctly detect X2APIC status in function enable_IR()
Date: Wed, 10 Dec 2014 14:47:44 +0800
Message-Id: <1418194071-13785-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
References: <1418194071-13785-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X2APIC will be disabled if user specifies "nox2apic" on kernel command
line, even when x2apic_preenabled is true. So correctly detect X2APIC
status by using x2apic_enabled() instead of x2apic_preenabled.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e7a426a589df..b6c473b97c5c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1580,7 +1580,7 @@ int __init enable_IR(void)
 		return -1;
 	}
 
-	if (!x2apic_preenabled && skip_ioapic_setup) {
+	if (!x2apic_enabled() && skip_ioapic_setup) {
 		pr_info("Skipped enabling intr-remap because of skipping "
 			"io-apic setup\n");
 		return -1;
-- 
1.7.10.4

