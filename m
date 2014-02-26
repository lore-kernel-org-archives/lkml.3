Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaBZThq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:37:46 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:53316 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaBZThl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:37:41 -0500
Subject: [PATCH 5/9] PCI: Don't clear IORESOURCE_UNSET when updating BAR
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 12:37:35 -0700
Message-ID: <20140226193735.10125.32502.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear IORESOURCE_UNSET when we assign an address to a resource, not when we
write the address to the BAR.

Also, drop the "BAR %d: set to %pR" message; this is mostly redundant with
the "BAR %d: assigned %pR" message from pci_assign_resource().

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/setup-res.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 0474b0217fdf..725d5b28398c 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -101,11 +101,6 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 
 	if (disable)
 		pci_write_config_word(dev, PCI_COMMAND, cmd);
-
-	res->flags &= ~IORESOURCE_UNSET;
-	dev_dbg(&dev->dev, "BAR %d: set to %pR (PCI address [%#llx-%#llx])\n",
-		resno, res, (unsigned long long)region.start,
-		(unsigned long long)region.end);
 }
 
 int pci_claim_resource(struct pci_dev *dev, int resource)

