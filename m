Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967716AbaLLMpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:45:54 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:21304 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966556AbaLLMpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:45:53 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <ralf@linux-mips.org>
CC: <Markos.Chandras@imgtec.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] mips: pci: Add ifdef around pci_proc_domain
Date: Fri, 12 Dec 2014 12:45:39 +0000
Message-ID: <1418388339-19750-1-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without these, there are multiple definitions of pci_proc_domain()
and pci_domain_nr() if linux/pci.h and asm/pci.h are included.

Add #ifdefs around them

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Reviewed-by: Markos Chandras <Markos.Chandras@imgtec.com>
---
 arch/mips/include/asm/pci.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/include/asm/pci.h b/arch/mips/include/asm/pci.h
index 6952962..193b4c6 100644
--- a/arch/mips/include/asm/pci.h
+++ b/arch/mips/include/asm/pci.h
@@ -121,6 +121,7 @@ static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 }
 #endif
 
+#ifdef CONFIG_PCI_DOMAINS
 #define pci_domain_nr(bus) ((struct pci_controller *)(bus)->sysdata)->index
 
 static inline int pci_proc_domain(struct pci_bus *bus)
@@ -128,6 +129,7 @@ static inline int pci_proc_domain(struct pci_bus *bus)
 	struct pci_controller *hose = bus->sysdata;
 	return hose->need_domain_info;
 }
+#endif /* CONFIG_PCI_DOMAINS */
 
 #endif /* __KERNEL__ */
 
-- 
1.9.1

