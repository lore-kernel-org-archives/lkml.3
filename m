Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab3K0B72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:59:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3K0A5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yuval Mintz <yuvalmin@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>
Subject: [PATCH 3.10 17/80] PCI: Allow PCIe Capability link-related register access for switches
Date: Tue, 26 Nov 2013 16:56:46 -0800
Message-Id: <20131127005642.136719368@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit d3694d4fa3f44f6a295f8ab064937c8a1549d174 upstream.

Every PCIe device has a link, except Root Complex Integrated Endpoints
and Root Complex Event Collectors.  Previously we didn't give access
to PCIe capability link-related registers for Upstream Ports, Downstream
Ports, and Bridges, so attempts to read PCI_EXP_LNKCTL incorrectly
returned zero.  See PCIe spec r3.0, sec 7.8 and 1.3.2.3.

Reference: http://lkml.kernel.org/r/979A8436335E3744ADCD3A9F2A2B68A52AD136BE@SJEXCHMB10.corp.ad.broadcom.com
Reported-by: Yuval Mintz <yuvalmin@broadcom.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-By: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/access.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -485,9 +485,13 @@ static inline bool pcie_cap_has_lnkctl(c
 	int type = pci_pcie_type(dev);
 
 	return pcie_cap_version(dev) > 1 ||
-	       type == PCI_EXP_TYPE_ROOT_PORT ||
 	       type == PCI_EXP_TYPE_ENDPOINT ||
-	       type == PCI_EXP_TYPE_LEG_END;
+	       type == PCI_EXP_TYPE_LEG_END ||
+	       type == PCI_EXP_TYPE_ROOT_PORT ||
+	       type == PCI_EXP_TYPE_UPSTREAM ||
+	       type == PCI_EXP_TYPE_DOWNSTREAM ||
+	       type == PCI_EXP_TYPE_PCI_BRIDGE ||
+	       type == PCI_EXP_TYPE_PCIE_BRIDGE;
 }
 
 static inline bool pcie_cap_has_sltctl(const struct pci_dev *dev)


