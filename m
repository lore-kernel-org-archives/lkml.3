Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbbAOEcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:32:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20416 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbbAOEco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:32:44 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Subject: [PATCH v2 08/10] PCI, parisc: clip firmware assigned resource under parent bridge's
Date: Wed, 14 Jan 2015 20:31:35 -0800
Message-Id: <1421296297-6371-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
References: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bios put range that is not fully coverred by root bus resources.
Try to clip them and update them in pci bridge bars.

We'd like to fix other arches instead of just x86.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
---
 drivers/parisc/lba_pci.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index 37e71ff..dceb9dd 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -694,9 +694,8 @@ lba_fixup_bus(struct pci_bus *bus)
 		int i;
 		/* PCI-PCI Bridge */
 		pci_read_bridge_bases(bus);
-		for (i = PCI_BRIDGE_RESOURCES; i < PCI_NUM_RESOURCES; i++) {
-			pci_claim_resource(bus->self, i);
-		}
+		for (i = PCI_BRIDGE_RESOURCES; i < PCI_NUM_RESOURCES; i++)
+			pci_claim_bridge_resource(bus->self, i);
 	} else {
 		/* Host-PCI Bridge */
 		int err;
-- 
1.8.4.5

