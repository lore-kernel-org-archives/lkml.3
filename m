Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaKHSL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:11:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:16054 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaKHSLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:11:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413533176"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiri Kosina <trivial@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [Patch Part3 v3 02/38] x86, intel-mid, trivial: Refine code syntax for sfi_parse_mtmr()
Date: Sun,  9 Nov 2014 02:13:02 +0800
Message-Id: <1415470418-10874-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly indent code in function sfi_parse_mtmr().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/platform/intel-mid/sfi.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index aa59f88868f8..9a16749935d4 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -95,16 +95,16 @@ int __init sfi_parse_mtmr(struct sfi_table_header *table)
 		pr_debug("timer[%d]: paddr = 0x%08x, freq = %dHz, irq = %d\n",
 			totallen, (u32)pentry->phys_addr,
 			pentry->freq_hz, pentry->irq);
-			mp_irq.type = MP_INTSRC;
-			mp_irq.irqtype = mp_INT;
-/* triggering mode edge bit 2-3, active high polarity bit 0-1 */
-			mp_irq.irqflag = 5;
-			mp_irq.srcbus = MP_BUS_ISA;
-			mp_irq.srcbusirq = pentry->irq;	/* IRQ */
-			mp_irq.dstapic = MP_APIC_ALL;
-			mp_irq.dstirq = pentry->irq;
-			mp_save_irq(&mp_irq);
-			mp_map_gsi_to_irq(pentry->irq, IOAPIC_MAP_ALLOC);
+		mp_irq.type = MP_INTSRC;
+		mp_irq.irqtype = mp_INT;
+		/* triggering mode edge bit 2-3, active high polarity bit 0-1 */
+		mp_irq.irqflag = 5;
+		mp_irq.srcbus = MP_BUS_ISA;
+		mp_irq.srcbusirq = pentry->irq;	/* IRQ */
+		mp_irq.dstapic = MP_APIC_ALL;
+		mp_irq.dstirq = pentry->irq;
+		mp_save_irq(&mp_irq);
+		mp_map_gsi_to_irq(pentry->irq, IOAPIC_MAP_ALLOC);
 	}
 
 	return 0;
-- 
1.7.10.4

