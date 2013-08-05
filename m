Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3HEUtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:49:17 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50970 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab3HEUmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:42:39 -0400
Message-ID: <aa84d2c5c743cae82a089bb187cfe648c928d79f.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 03/20] tile PCI RC: support pci=off boot arg for tilepro
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 1dae3b2..af75835 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -51,6 +51,8 @@
  *
  */
 
+static int pci_probe = 1;
+
 /*
  * This flag tells if the platform is TILEmpower that needs
  * special configuration for the PLX switch chip.
@@ -143,6 +145,11 @@ int __init tile_pci_init(void)
 {
 	int i;
 
+	if (!pci_probe) {
+		pr_info("PCI: disabled by boot argument\n");
+		return 0;
+	}
+
 	pr_info("PCI: Searching for controllers...\n");
 
 	/* Re-init number of PCIe controllers to support hot-plug feature. */
@@ -378,6 +385,16 @@ void pcibios_set_master(struct pci_dev *dev)
 	/* No special bus mastering setup handling. */
 }
 
+/* Process any "pci=" kernel boot arguments. */
+char * __init pcibios_setup(char *str)
+{
+	if (!strcmp(str, "off")) {
+		pci_probe = 0;
+		return NULL;
+	}
+	return str;
+}
+
 /*
  * Enable memory and/or address decoding, as appropriate, for the
  * device described by the 'dev' struct.
-- 
1.8.3.1

