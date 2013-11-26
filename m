Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab3KZSSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:18:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716Ab3KZSND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:13:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 3.11 20/36] PCI: Remove PCIe Capability version checks
Date: Tue, 26 Nov 2013 10:12:30 -0800
Message-Id: <20131126181029.271774771@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131126181025.029404973@linuxfoundation.org>
References: <20131126181025.029404973@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit c8b303d0206b28c4ff3aecada47108d1655ae00f upstream.

Previously we relied on the PCIe r3.0, sec 7.8, spec language that says
"For Functions that do not implement the [Link, Slot, Root] registers,
these spaces must be hardwired to 0b," which means that for v2 PCIe
capabilities, we don't need to check the device type at all.

But it's simpler if we don't need to check the capability version at all,
and I think the spec is explicit enough about which registers are required
for which types that we can remove the version checks.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-By: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Myron Stowe <myron.stowe@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/access.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -484,8 +484,7 @@ static inline bool pcie_cap_has_lnkctl(c
 {
 	int type = pci_pcie_type(dev);
 
-	return pcie_cap_version(dev) > 1 ||
-	       type == PCI_EXP_TYPE_ENDPOINT ||
+	return type == PCI_EXP_TYPE_ENDPOINT ||
 	       type == PCI_EXP_TYPE_LEG_END ||
 	       type == PCI_EXP_TYPE_ROOT_PORT ||
 	       type == PCI_EXP_TYPE_UPSTREAM ||
@@ -498,8 +497,7 @@ static inline bool pcie_cap_has_sltctl(c
 {
 	int type = pci_pcie_type(dev);
 
-	return pcie_cap_version(dev) > 1 ||
-	       type == PCI_EXP_TYPE_ROOT_PORT ||
+	return type == PCI_EXP_TYPE_ROOT_PORT ||
 	       (type == PCI_EXP_TYPE_DOWNSTREAM &&
 		pcie_caps_reg(dev) & PCI_EXP_FLAGS_SLOT);
 }
@@ -508,8 +506,7 @@ static inline bool pcie_cap_has_rtctl(co
 {
 	int type = pci_pcie_type(dev);
 
-	return pcie_cap_version(dev) > 1 ||
-	       type == PCI_EXP_TYPE_ROOT_PORT ||
+	return type == PCI_EXP_TYPE_ROOT_PORT ||
 	       type == PCI_EXP_TYPE_RC_EC;
 }
 


