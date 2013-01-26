Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3AZAzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 19:55:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab3AZAzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:55:45 -0500
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 1/2] PCI: introduce accessor to retrieve PCIe Capabilities
	Register
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, jiang.liu@huawei.com, mcgrof@qca.qualcomm.com,
        mcgrof@do-not-panic.com, linux-kernel@vger.kernel.org
Date: Fri, 25 Jan 2013 17:55:39 -0700
Message-ID: <20130126005539.25808.86935.stgit@amt.stowe>
In-Reply-To: <20130126005533.25808.23022.stgit@amt.stowe>
References: <20130126005533.25808.23022.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an accessor to retrieve the PCI Express device's Capabilities
Register.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 include/linux/pci.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 15472d6..78581e1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1693,6 +1693,15 @@ static inline bool pci_is_pcie(struct pci_dev *dev)
 }
 
 /**
+ * pcie_caps_reg - get the PCIe Capabilities Register
+ * @dev: PCI device
+ */
+static inline u16 pcie_caps_reg(const struct pci_dev *dev)
+{
+	return dev->pcie_flags_reg;
+}
+
+/**
  * pci_pcie_type - get the PCIe device/port type
  * @dev: PCI device
  */

