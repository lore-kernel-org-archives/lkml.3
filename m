Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3CKIpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:45:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:8162 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab3CKIpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:45:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,822,1355126400"; 
   d="scan'208";a="299782644"
Subject: [PATCH 1/3] x86, io_apic: Adding the flag IRQCHIP_SKIP_SET_WAKE
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de, joro@8bytes.org
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1363024396.31506.60.camel@cliu38-desktop-build>
References: <1363024396.31506.60.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Mar 2013 01:55:11 +0800
Message-ID: <1363024511.31506.62.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently for an ioapic chip irq, if we call irq_set_irq_wake()
we will get the ENXIO returning error, but some drivers need the
wake-up interrupts pending mechanism.

Here adding the flag IRQCHIP_SKIP_SET_WAKE instead of emtpy callback.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9ed796c..7d0baf7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2520,6 +2520,7 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.irq_eoi		= ack_apic_level,
 	.irq_set_affinity	= native_ioapic_set_affinity,
 	.irq_retrigger		= ioapic_retrigger_irq,
+	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
 static inline void init_IO_APIC_traps(void)
-- 
1.7.0.4



