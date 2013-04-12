Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435Ab3DLWtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:49:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47196 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab3DLWpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:45:09 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 07/29] PCI, x86: Use for_each_pci_resource() with pci_allocate_bridge_resources
Date: Fri, 12 Apr 2013 15:44:21 -0700
Message-Id: <1365806683-26717-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/i386.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 94919e3..7c3395a 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -206,8 +206,7 @@ static void pcibios_allocate_bridge_resources(struct pci_dev *dev)
 	int idx;
 	struct resource *r;
 
-	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
-		r = &dev->resource[idx];
+	for_each_pci_resource(dev, r, idx, PCI_BRIDGE_RES) {
 		if (!r->flags)
 			continue;
 		if (!r->start || pci_claim_resource(dev, idx) < 0) {
-- 
1.8.1.4

