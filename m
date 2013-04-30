Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924Ab3D3XRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:17:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:47303 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933835Ab3D3XRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:17:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,584,1363158000"; 
   d="scan'208";a="326817444"
From: David Cohen <david.a.cohen@intel.com>
To: mingo@redhat.com, joro@8bytes.org, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@intel.com>
Subject: [PATCH] x86, io_apic: Fix number of pre-allocated irqs
Date: Tue, 30 Apr 2013 16:20:15 -0700
Message-Id: <1367364015-12521-1-git-send-email-david.a.cohen@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_probe_nr_irqs() has a typo when returning number of preallocated
irqs. Instead of returning the calculated value, it returns a constant
number NR_IRQ_LEGACY.
This patch makes sure the calculated value is returned intead.

Signed-off-by: David Cohen <david.a.cohen@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9ed796c..7ef2bd9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3437,7 +3437,7 @@ int __init arch_probe_nr_irqs(void)
 	if (nr < nr_irqs)
 		nr_irqs = nr;
 
-	return NR_IRQS_LEGACY;
+	return nr;
 }
 
 int io_apic_set_pci_routing(struct device *dev, int irq,
-- 
1.7.10.4

