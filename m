Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3DLWo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:44:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46511 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3DLWoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:44:54 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 05/29] PCI: Add is_pci_*_resource_idx() helpers
Date: Fri, 12 Apr 2013 15:44:19 -0700
Message-Id: <1365806683-26717-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to resource pointer find out if the resource is some type resource
like bridge, sriov, or std.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/pci.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index f4da78d..14b7de4 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -107,6 +107,29 @@ enum {
 	DEVICE_COUNT_RESOURCE = PCI_NUM_RESOURCES,
 };
 
+static inline bool is_pci_std_resource_idx(int i)
+{
+	return i >= PCI_STD_RESOURCES && i <= PCI_STD_RESOURCE_END;
+}
+
+static inline bool is_pci_rom_resource_idx(int i)
+{
+	return i == PCI_ROM_RESOURCE;
+}
+
+static inline bool is_pci_iov_resource_idx(int i)
+{
+#ifdef CONFIG_PCI_IOV
+	return i >= PCI_IOV_RESOURCES && i <= PCI_IOV_RESOURCE_END;
+#endif
+	return false;
+}
+
+static inline bool is_pci_bridge_resource_idx(int i)
+{
+	return i >= PCI_BRIDGE_RESOURCES && i <= PCI_BRIDGE_RESOURCE_END;
+}
+
 typedef int __bitwise pci_power_t;
 
 #define PCI_D0		((pci_power_t __force) 0)
-- 
1.8.1.4

