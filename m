Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3DLWpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:45:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47249 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3DLWpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:45:19 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH v4 16/29] PCI, x86: Use for_each_pci_resource() with noassign_bars
Date: Fri, 12 Apr 2013 15:44:30 -0700
Message-Id: <1365806683-26717-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
References: <1365806683-26717-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace those open code, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
Cc: Myron Stowe <myron.stowe@redhat.com>
---
 arch/x86/pci/common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 901177d..a2afe2e 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -136,8 +136,7 @@ static void pcibios_fixup_device_resources(struct pci_dev *dev)
 		* resource so the kernel doesn't attmept to assign
 		* it later on in pci_assign_unassigned_resources
 		*/
-		for (bar = 0; bar <= PCI_STD_RESOURCE_END; bar++) {
-			bar_r = &dev->resource[bar];
+		for_each_pci_resource(dev, bar_r, bar, PCI_STD_RES) {
 			if (bar_r->start == 0 && bar_r->end != 0) {
 				bar_r->flags = 0;
 				bar_r->end = 0;
-- 
1.8.1.4

