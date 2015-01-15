Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbbAOVWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:58365 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbbAOVWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:47 -0500
Message-Id: <20150115211703.397170414@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 14/23] x86/ioapic: Provide stub functions for IOAPIC=n
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=x86-ioapic-add-proper-checks-provide-stubs.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid lots of ifdeffery provide proper stubs for setup_IO_APIC(),
enable_IO_APIC() and setup_ioapic_dest().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/io_apic.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: tip/arch/x86/include/asm/io_apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/io_apic.h
+++ tip/arch/x86/include/asm/io_apic.h
@@ -279,6 +279,11 @@ static inline void disable_ioapic_suppor
 #define native_ioapic_set_affinity	NULL
 #define native_setup_ioapic_entry	NULL
 #define native_eoi_ioapic_pin		NULL
+
+static inline void setup_IO_APIC(void) { }
+static inline void enable_IO_APIC(void) { }
+static inline void setup_ioapic_dest(void) { }
+
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */


