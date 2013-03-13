Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051Ab3CMX3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:29:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17874 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab3CMX3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:29:34 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 20/27] PCI, xen: Use for_each_pci_resource() with xen pci
Date: Wed, 13 Mar 2013 16:28:15 -0700
Message-Id: <1363217302-14383-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: virtualization@lists.linux-foundation.org
---
 drivers/pci/xen-pcifront.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 966abc6..c90835f 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -395,9 +395,7 @@ static int pcifront_claim_resource(struct pci_dev *dev, void *data)
 	int i;
 	struct resource *r;
 
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-		r = &dev->resource[i];
-
+	for_each_pci_resource(dev, r, i, PCI_ALL_RES) {
 		if (!r->parent && r->start && r->flags) {
 			dev_info(&pdev->xdev->dev, "claiming resource %s/%d\n",
 				pci_name(dev), i);
-- 
1.7.10.4

