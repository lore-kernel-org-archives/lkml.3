Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaBZXlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:41:42 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:45387 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbaBZXlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:41:39 -0500
Subject: [PATCH 1/7] PCI: Add "weak" generic pcibios_enable_device()
 implementation
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 16:41:36 -0700
Message-ID: <20140226234136.18970.21352.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many architectures implement pcibios_enable_device() the same way, so
provide a default implementation in the core.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index dc9ce62be7aa..c3ce3d61091c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1185,6 +1185,11 @@ int pci_load_and_free_saved_state(struct pci_dev *dev,
 }
 EXPORT_SYMBOL_GPL(pci_load_and_free_saved_state);
 
+int __weak pcibios_enable_device(struct pci_dev *dev, int bars)
+{
+	return pci_enable_resources(dev, bars);
+}
+
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
 {
 	int err;

