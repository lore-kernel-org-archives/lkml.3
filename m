Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaHDTBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:01:24 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:64878 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaHDTBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:01:23 -0400
Date: Mon, 4 Aug 2014 21:01:17 +0200
From: Quentin Lambert <lambert.quentin@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Scott Murray <scott@spiteful.org>,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] PCI hotplug: fix a simple if coding style issue
Message-ID: <20140804190117.GA4243@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing curly braces in simple if cases.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/pci/hotplug/cpcihp_zt5550.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/hotplug/cpcihp_zt5550.c b/drivers/pci/hotplug/cpcihp_zt5550.c
index 42a61c2..2b222fc 100644
--- a/drivers/pci/hotplug/cpcihp_zt5550.c
+++ b/drivers/pci/hotplug/cpcihp_zt5550.c
@@ -182,9 +182,9 @@ static int zt5550_hc_enable_irq(void)
 {
 	u8 reg;
 
-	if (hc_dev == NULL) {
+	if (hc_dev == NULL) 
 		return -ENODEV;
-	}
+
 	reg = readb(csr_int_mask);
 	reg = reg & ~ENUM_INT_MASK;
 	writeb(reg, csr_int_mask);
@@ -195,9 +195,8 @@ static int zt5550_hc_disable_irq(void)
 {
 	u8 reg;
 
-	if (hc_dev == NULL) {
+	if (hc_dev == NULL)
 		return -ENODEV;
-	}
 
 	reg = readb(csr_int_mask);
 	reg = reg | ENUM_INT_MASK;
@@ -210,9 +209,9 @@ static int zt5550_hc_init_one (struct pci_dev *pdev, const struct pci_device_id
 	int status;
 
 	status = zt5550_hc_config(pdev);
-	if (status != 0) {
+	if (status != 0)
 		return status;
-	}
+
 	dbg("returned from zt5550_hc_config");
 
 	memset(&zt5550_hpc, 0, sizeof (struct cpci_hp_controller));
-- 
1.9.1

