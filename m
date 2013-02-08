Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619Ab3BHTbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:31:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34195 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760531Ab3BHTaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:30:30 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v2 09/26] x86, irq: kill create_irq()
Date: Fri,  8 Feb 2013 11:28:06 -0800
Message-Id: <1360351703-20571-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_irq() will return -1 when fail to allocate.
create_irq_nr() will return 0 when fail to allocate.

It only causes confusing.

Now we have no user for create_irq(), so remove create_irq() for x86.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 arch/x86/kernel/apic/io_apic.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c703092..4c1a726 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2968,21 +2968,6 @@ unsigned int create_irq_nr(unsigned int from, int node)
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
1.7.10.4

