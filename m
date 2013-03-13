Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079Ab3CMX3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:29:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51536 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab3CMX3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:29:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH v3 15/27] PCI, x86: Use for_each_pci_resource() with noassign_bars
Date: Wed, 13 Mar 2013 16:28:10 -0700
Message-Id: <1363217302-14383-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace those open code, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
Cc: Myron Stowe <myron.stowe@redhat.com>
---
 arch/x86/pci/common.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 901177d..fe85836 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -136,8 +136,7 @@ static void pcibios_fixup_device_resources(struct pci_dev *dev)
 		* resource so the kernel doesn't attmept to assign
 		* it later on in pci_assign_unassigned_resources
 		*/
-		for (bar = 0; bar <= PCI_STD_RESOURCE_END; bar++) {
-			bar_r = &dev->resource[bar];
+		for_each_pci_resource(dev, bar_r, bar, PCI_NOIOV_RES & ~PCI_BRIDGE_RES & ~PCI_ROM_RES) {
 			if (bar_r->start == 0 && bar_r->end != 0) {
 				bar_r->flags = 0;
 				bar_r->end = 0;
-- 
1.7.10.4

