Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaBZXmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:42:15 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:61178 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbaBZXmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:42:11 -0500
Subject: [PATCH 6/7] tile PCI RC: Use default pcibios_enable_device()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 26 Feb 2014 16:42:08 -0700
Message-ID: <20140226234208.18970.41395.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need anything arch-specific in pcibios_enable_device(), so drop
the arch implementation and use the default generic one.

Note: pci_enable_resources() checks that r->parent is non-NULL, which
basically checks that pci_claim_resource() or request_resource() has been
called for each BAR.  I don't see where that happens for tile, but this
patch doesn't change that behavior, so if it worked before, it should still
work.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci_gx.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index a97a6452b812..077b7bc437e5 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -1065,18 +1065,6 @@ char *__init pcibios_setup(char *str)
 }
 
 /*
- * Enable memory address decoding, as appropriate, for the
- * device described by the 'dev' struct.
- *
- * This is called from the generic PCI layer, and can be called
- * for bridges or endpoints.
- */
-int pcibios_enable_device(struct pci_dev *dev, int mask)
-{
-	return pci_enable_resources(dev, mask);
-}
-
-/*
  * Called for each device after PCI setup is done.
  * We initialize the PCI device capabilities conservatively, assuming that
  * all devices can only address the 32-bit DMA space. The exception here is

