Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbaFIIYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:24:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:59249 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193AbaFIIY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:24:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="352322096"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>, Michal Simek <monstr@monstr.eu>,
        Tony Lindgren <tony@atomide.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch V4 41/42] x86, irq, devicetree: release IOAPIC pin when PCI device is disabled
Date: Mon,  9 Jun 2014 16:20:10 +0800
Message-Id: <1402302011-23642-42-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Release IOAPIC pin associated with PCI device when the PCI device
is disabled.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/devicetree.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 0c938dd7b3c8..8dcd11b08669 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -226,6 +226,7 @@ static int ioapic_xlate(struct irq_domain *domain,
 
 const struct irq_domain_ops ioapic_irq_domain_ops = {
 	.map = mp_irqdomain_map,
+	.unmap = mp_irqdomain_unmap,
 	.xlate = ioapic_xlate,
 };
 
-- 
1.7.10.4

