Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3K3Wl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 17:41:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21639 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3K3Wkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 17:40:47 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 09/12] PCI: Kill PCIBIOS_MAX_MEM_32
Date: Sat, 30 Nov 2013 14:40:35 -0800
Message-Id: <1385851238-21085-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No user anymore.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/pci.h | 1 -
 include/linux/pci.h        | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 947b5c4..122c299 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -125,7 +125,6 @@ int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 
 /* generic pci stuff */
 #include <asm-generic/pci.h>
-#define PCIBIOS_MAX_MEM_32 0xffffffff
 
 #ifdef CONFIG_NUMA
 /* Returns the node based on pci bus */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a51b343..46bf01c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1491,10 +1491,6 @@ static inline struct pci_dev *pci_dev_get(struct pci_dev *dev)
 
 #include <asm/pci.h>
 
-#ifndef PCIBIOS_MAX_MEM_32
-#define PCIBIOS_MAX_MEM_32 (-1)
-#endif
-
 /* these helpers provide future and backwards compatibility
  * for accessing popular PCI BAR info */
 #define pci_resource_start(dev, bar)	((dev)->resource[(bar)].start)
-- 
1.8.1.4

