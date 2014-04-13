Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaDMHti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 03:49:38 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:44012 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147AbaDMHth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 03:49:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AncGAE1ASlNXQ5wQ/2dsb2JhbABZgwbEP4EYF3SCZhwjGIECJBOIAAHKWI5uhD8BA45figEBimSHX4MzOw
Date: Sun, 13 Apr 2014 09:49:34 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, linux-pci@vger.kernel.org
Subject: [PATCH 1/1] drivers/pci/pcie/portdrv_pci.c: coding style fixes
Message-Id: <20140413094934.423504a748c16f48bdd7fd70@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move __initdata before equal sign
printk(KERN_WARNING converted to pr_warn

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/pci/pcie/portdrv_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 0d8fdc4..14eb431 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -402,7 +402,7 @@ static int __init dmi_pcie_pme_disable_msi(const struct dmi_system_id *d)
 	return 0;
 }
 
-static struct dmi_system_id __initdata pcie_portdrv_dmi_table[] = {
+static struct dmi_system_id pcie_portdrv_dmi_table[] __initdata = {
 	/*
 	 * Boxes that should not use MSI for PCIe PME signaling.
 	 */
@@ -429,7 +429,7 @@ static int __init pcie_portdrv_init(void)
 
 	retval = pcie_port_bus_register();
 	if (retval) {
-		printk(KERN_WARNING "PCIE: bus_register error: %d\n", retval);
+		pr_warn("PCIE: bus_register error: %d\n", retval);
 		goto out;
 	}
 	retval = pci_register_driver(&pcie_portdriver);
-- 
1.8.3.2
