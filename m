Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaKZXTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:19:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58933 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaKZXS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:18:56 -0500
Date: Wed, 26 Nov 2014 15:13:08 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-11ed0c3f6fc7a0adac92b21b2a5a8e31943fcd42@git.kernel.org>
Cc: rjw@rjwysocki.net, hpa@zytor.com, hpa@linux.intel.com,
        jiang.liu@linux.intel.com, rdunlap@infradead.org,
        konrad.wilk@oracle.com, gregkh@linuxfoundation.org, joro@8bytes.org,
        tony.luck@intel.com, david.a.cohen@linux.intel.com,
        bhelgaas@google.com, benh@kernel.crashing.org, tglx@linutronix.de,
        trivial@kernel.org, mingo@kernel.org,
        andriy.shevchenko@linux.intel.com, bp@alien8.de,
        linux-kernel@vger.kernel.org, yinghai@kernel.org
Reply-To: bhelgaas@google.com, tglx@linutronix.de, trivial@kernel.org,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, mingo@kernel.org, bp@alien8.de,
        yinghai@kernel.org, hpa@zytor.com, rjw@rjwysocki.net,
        jiang.liu@linux.intel.com, hpa@linux.intel.com, rdunlap@infradead.org,
        konrad.wilk@oracle.com, tony.luck@intel.com,
        david.a.cohen@linux.intel.com, gregkh@linuxfoundation.org,
        joro@8bytes.org
In-Reply-To: <1416901802-24211-3-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-3-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, intel-mid, trivial:
  Refine code syntax for sfi_parse_mtmr()
Git-Commit-ID: 11ed0c3f6fc7a0adac92b21b2a5a8e31943fcd42
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

Commit-ID:  11ed0c3f6fc7a0adac92b21b2a5a8e31943fcd42
Gitweb:     http://git.kernel.org/tip/11ed0c3f6fc7a0adac92b21b2a5a8e31943fcd42
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:26 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:46 +0100

x86, intel-mid, trivial: Refine code syntax for sfi_parse_mtmr()

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
 arch/x86/platform/intel-mid/sfi.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index aa59f88..9a16749 100644
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
