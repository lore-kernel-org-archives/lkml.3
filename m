Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaACAHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:07:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21852 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbaACAH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:07:28 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v5 11/33] x86, irq: Kill create_irq()
Date: Thu,  2 Jan 2014 16:05:43 -0800
Message-Id: <1388707565-16535-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_irq() will return -1 when failing to allocate.
create_irq_nr() will return 0 when failing to allocate.

It only causes confusion.

Now we have no user for create_irq(), so remove create_irq() for x86.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 241325c..86d5466 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2973,21 +2973,6 @@ unsigned int create_irq_nr(unsigned int from, int node)
 	return __create_irqs(from, 1, node);
 }
 
-int create_irq(void)
-{
-	int node = cpu_to_node(0);
-	unsigned int irq_want;
-	int irq;
-
-	irq_want = nr_irqs_gsi;
-	irq = create_irq_nr(irq_want, node);
-
-	if (irq == 0)
-		irq = -1;
-
-	return irq;
-}
-
 void destroy_irq(unsigned int irq)
 {
 	struct irq_cfg *cfg = irq_get_chip_data(irq);
-- 
1.8.4

