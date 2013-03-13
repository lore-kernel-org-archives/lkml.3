Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883Ab3CMXeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:34:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17543 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793Ab3CMX2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:32 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 04/27] PCI: Add is_pci_*_resource_idx() helpers
Date: Wed, 13 Mar 2013 16:27:59 -0700
Message-Id: <1363217302-14383-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to resource pointer find out if the resource is some type resource
like bridge, sriov, or std.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/pci.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 127a856..efb348b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -92,6 +92,29 @@ enum {
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
1.7.10.4

