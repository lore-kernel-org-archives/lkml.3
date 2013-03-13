Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012Ab3CMX2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:28:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51276 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964992Ab3CMX2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:46 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH v3 19/27] PCI, x86: Use for_each_pci_resource() with mrst
Date: Wed, 13 Mar 2013 16:28:14 -0700
Message-Id: <1363217302-14383-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
Cc: Huang Ying <ying.huang@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 arch/x86/pci/mrst.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 6eb18c4..884ea69 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -280,6 +280,7 @@ static void pci_fixed_bar_fixup(struct pci_dev *dev)
 	unsigned long offset;
 	u32 size;
 	int i;
+	struct resource *res;
 
 	if (!pci_soc_mode)
 		return;
@@ -294,10 +295,10 @@ static void pci_fixed_bar_fixup(struct pci_dev *dev)
 	    PCI_DEVFN(2, 2) == dev->devfn)
 		return;
 
-	for (i = 0; i < PCI_ROM_RESOURCE; i++) {
+	for_each_pci_resource(dev, res, i, PCI_STD_RES) {
 		pci_read_config_dword(dev, offset + 8 + (i * 4), &size);
-		dev->resource[i].end = dev->resource[i].start + size - 1;
-		dev->resource[i].flags |= IORESOURCE_PCI_FIXED;
+		res->end = res->start + size - 1;
+		res->flags |= IORESOURCE_PCI_FIXED;
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_fixed_bar_fixup);
-- 
1.7.10.4

