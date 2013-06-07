Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab3FGWgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 18:36:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51748 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571Ab3FGWdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 18:33:18 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v3 08/27] x86, irq: kill create_irq()
Date: Fri,  7 Jun 2013 15:30:54 -0700
Message-Id: <1370644273-10495-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
References: <1370644273-10495-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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
index 436fb38..70b6617 100644
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
1.8.1.4

