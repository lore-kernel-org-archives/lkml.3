Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab3DLWrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:47:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47687 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3DLWrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:47:07 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 25/29] PCI: Update pci_resource_bar() to support addon_resource
Date: Fri, 12 Apr 2013 15:44:39 -0700
Message-Id: <1365806683-26717-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need to loop addon resource list to retrieve reg_addr in it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c1010be..7677c6b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3613,6 +3613,13 @@ int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type)
 		reg = pci_iov_resource_bar(dev, resno, type);
 		if (reg)
 			return reg;
+	} else if (resno >= PCI_NUM_RESOURCES) {
+		struct resource *res = pci_dev_resource_n(dev, resno);
+
+		if (res) {
+			*type = pci_bar_unknown;
+			return to_pci_dev_addon_resource(res)->reg_addr;
+		}
 	}
 
 	dev_err(&dev->dev, "BAR %d: invalid resource\n", resno);
-- 
1.8.1.4

