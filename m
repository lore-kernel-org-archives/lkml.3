Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbaICJ5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:57:33 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57404 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932229AbaICJ5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:57:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 10/56] PCI: Add pci_upstream_bridge()
Date: Wed,  3 Sep 2014 11:26:29 +0200
Message-Id: <5d1ab637d00b258f7852c963771ed4f1fd0b2de3.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c6bde215acfd637708142ae671843b6f0eadbc6d upstream.

This adds a pci_upstream_bridge() interface to find the PCI-to-PCI bridge
upstream from a device.  This is typically just "dev->bus->self", but in
the case of a VF on a virtual bus, we have to start from the corresponding
PF.  Returns NULL if there is no upstream PCI bridge, i.e., if the device
is on a root bus.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/pci.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index da172f956ad6..db4ce115705e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -478,6 +478,15 @@ static inline bool pci_is_root_bus(struct pci_bus *pbus)
 	return !(pbus->parent);
 }
 
+static inline struct pci_dev *pci_upstream_bridge(struct pci_dev *dev)
+{
+	dev = pci_physfn(dev);
+	if (pci_is_root_bus(dev->bus))
+		return NULL;
+
+	return dev->bus->self;
+}
+
 #ifdef CONFIG_PCI_MSI
 static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev)
 {
-- 
2.1.0

