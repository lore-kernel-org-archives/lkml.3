Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaACAGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:06:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21426 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaACAF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:05:56 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v5 09/33] ia64, irq: Add dummy create_irq_nr()
Date: Thu,  2 Jan 2014 16:05:41 -0800
Message-Id: <1388707565-16535-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_irq() will return -1 when fail to allocate.
create_irq_nr() will return 0 when fail to allocate.

Will use it to fix one return value checking for dmar_msi irq.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Cc: stable@vger.kernel.org
---
 arch/ia64/kernel/irq_ia64.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 1034884..38e46df 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -429,6 +429,16 @@ int create_irq(void)
 	return irq;
 }
 
+unsigned int create_irq_nr(unsigned int from, int node)
+{
+	int irq = create_irq();
+
+	if (irq < 0)
+		irq = 0;
+
+	return irq;
+}
+
 void destroy_irq(unsigned int irq)
 {
 	dynamic_irq_cleanup(irq);
-- 
1.8.4

