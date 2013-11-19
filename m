Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab3KSVf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:35:59 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34859 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab3KSVfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:35:53 -0500
Subject: [PATCH v2 2/3] PCI: Remove PCIe Capability version checks
To: stable@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        Amos Kong <kongjianjun@gmail.com>, Adam Lee <adam.lee@canonical.com>,
        linux-kernel@vger.kernel.org, Yuval Mintz <yuvalmin@broadcom.com>,
        Ben Hutchings <ben@decadent.org.uk>, Thomas Renninger <trenn@suse.de>
Date: Tue, 19 Nov 2013 14:35:50 -0700
Message-ID: <20131119213550.3839.2581.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20131119212714.3839.52182.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131119212714.3839.52182.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c8b303d0206b28c4ff3aecada47108d1655ae00f upstream.  This is part
of the fix for https://bugzilla.kernel.org/show_bug.cgi?id=65211

Previously we relied on the PCIe r3.0, sec 7.8, spec language that says
"For Functions that do not implement the [Link, Slot, Root] registers,
these spaces must be hardwired to 0b," which means that for v2 PCIe
capabilities, we don't need to check the device type at all.

But it's simpler if we don't need to check the capability version at all,
and I think the spec is explicit enough about which registers are required
for which types that we can remove the version checks.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-By: Jiang Liu <jiang.liu@huawei.com>
CC: stable@vger.kernel.org	# v3.7+
---
 drivers/pci/access.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index e26c3bd9aca4..9a46fa9135d9 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -484,8 +484,7 @@ static inline bool pcie_cap_has_lnkctl(const struct pci_dev *dev)
 {
 	int type = pci_pcie_type(dev);
 
-	return pcie_cap_version(dev) > 1 ||
-	       type == PCI_EXP_TYPE_ENDPOINT ||
+	return type == PCI_EXP_TYPE_ENDPOINT ||
 	       type == PCI_EXP_TYPE_LEG_END ||
 	       type == PCI_EXP_TYPE_ROOT_PORT ||
 	       type == PCI_EXP_TYPE_UPSTREAM ||
@@ -498,8 +497,7 @@ static inline bool pcie_cap_has_sltctl(const struct pci_dev *dev)
 {
 	int type = pci_pcie_type(dev);
 
-	return pcie_cap_version(dev) > 1 ||
-	       type == PCI_EXP_TYPE_ROOT_PORT ||
+	return type == PCI_EXP_TYPE_ROOT_PORT ||
 	       (type == PCI_EXP_TYPE_DOWNSTREAM &&
 		pcie_caps_reg(dev) & PCI_EXP_FLAGS_SLOT);
 }
@@ -508,8 +506,7 @@ static inline bool pcie_cap_has_rtctl(const struct pci_dev *dev)
 {
 	int type = pci_pcie_type(dev);
 
-	return pcie_cap_version(dev) > 1 ||
-	       type == PCI_EXP_TYPE_ROOT_PORT ||
+	return type == PCI_EXP_TYPE_ROOT_PORT ||
 	       type == PCI_EXP_TYPE_RC_EC;
 }
 

