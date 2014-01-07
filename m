Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbaAGA4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:56:44 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:60773 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760AbaAGA4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:56:40 -0500
Subject: [PATCH v7 12/15] agp/ati: Use PCI_COMMAND instead of hard-coded 4
To: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 17:56:38 -0700
Message-ID: <20140107005637.10786.2267.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're accessing the PCI_COMMAND register here, so use the appropriate
#define.  The bit we're writing (1 << 14) isn't defined by the PCI or PCIe
spec, so we don't have a name for it.

No functional change.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/char/agp/ati-agp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index ba83c11186ce..18a7a6baa304 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -221,8 +221,8 @@ static int ati_configure(void)
 	readl(ati_generic_private.registers+ATI_GART_FEATURE_ID);	/* PCI Posting.*/
 
 	/* SIGNALED_SYSTEM_ERROR @ NB_STATUS */
-	pci_read_config_dword(agp_bridge->dev, 4, &temp);
-	pci_write_config_dword(agp_bridge->dev, 4, temp | (1<<14));
+	pci_read_config_dword(agp_bridge->dev, PCI_COMMAND, &temp);
+	pci_write_config_dword(agp_bridge->dev, PCI_COMMAND, temp | (1<<14));
 
 	/* Write out the address of the gatt table */
 	writel(agp_bridge->gatt_bus_addr, ati_generic_private.registers+ATI_GART_BASE);

