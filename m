Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469Ab3CMXcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:32:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17596 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964891Ab3CMX2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:38 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 16/27] PCI: Use for_each_pci_resource() in pci_dev_driver()
Date: Wed, 13 Mar 2013 16:28:11 -0700
Message-Id: <1363217302-14383-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace those open code, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci-driver.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 1fa1e48..866149a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1170,9 +1170,11 @@ pci_dev_driver(const struct pci_dev *dev)
 	if (dev->driver)
 		return dev->driver;
 	else {
+		struct resource *res;
 		int i;
-		for(i=0; i<=PCI_ROM_RESOURCE; i++)
-			if (dev->resource[i].flags & IORESOURCE_BUSY)
+
+		for_each_pci_resource((struct pci_dev *)dev, res, i, PCI_NOIOV_RES & ~PCI_BRIDGE_RES)
+			if (res->flags & IORESOURCE_BUSY)
 				return &pci_compat_driver;
 	}
 	return NULL;
-- 
1.7.10.4

