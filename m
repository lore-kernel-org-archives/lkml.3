Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbbATDMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:12:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:44424 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbbATDMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:12:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442529727"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiri Kosina <trivial@kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [Patch Part1 v7 30/38] x86/intel-mid, trivial: Refine code syntax for sfi_parse_mtmr()
Date: Tue, 20 Jan 2015 11:08:33 +0800
Message-Id: <1421723321-8386-31-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly indent code in function sfi_parse_mtmr().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1416901802-24211-3-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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

