Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826Ab3CMXfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:35:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17532 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934431Ab3CMX2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 06/27] PCI, x86: Use for_each_pci_resource() with pci_allocate_bridge_resources
Date: Wed, 13 Mar 2013 16:28:01 -0700
Message-Id: <1363217302-14383-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/i386.c |    3 +--
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
1.7.10.4

