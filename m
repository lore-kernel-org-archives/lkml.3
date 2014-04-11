Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaDKFC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 01:02:28 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:60064 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaDKFCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 01:02:24 -0400
X-Originating-IP: 76.119.93.133
From: Ryan Desfosses <ryan@desfo.org>
To: bhelgaas@google.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Ryan Desfosses <ryan@desfo.org>
Subject: [PATCHv2] pci: changed "foo* bar" to "foo *bar"
Date: Fri, 11 Apr 2014 01:01:53 -0400
Message-Id: <1397192513-4498-1-git-send-email-ryan@desfo.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change made to resolve following checkpatch message:
    drivers/pci/pci.c:109: ERROR: "foo* bar" should be "foo *bar"
branch: Linux 3.14-rc8

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
---
 drivers/pci/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index fdbc294..4070a60 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -106,7 +106,7 @@ static bool pcie_ari_disabled;
  * Given a PCI bus, returns the highest PCI bus number present in the set
  * including the given PCI bus and its list of child PCI buses.
  */
-unsigned char pci_bus_max_busnr(struct pci_bus* bus)
+unsigned char pci_bus_max_busnr(struct pci_bus *bus)
 {
 	struct list_head *tmp;
 	unsigned char max, n;
@@ -1359,7 +1359,7 @@ static void pcim_release(struct device *gendev, void *res)
 		pci_disable_device(dev);
 }
 
-static struct pci_devres * get_pci_dr(struct pci_dev *pdev)
+static struct pci_devres *get_pci_dr(struct pci_dev *pdev)
 {
 	struct pci_devres *dr, *new_dr;
 
@@ -1373,7 +1373,7 @@ static struct pci_devres * get_pci_dr(struct pci_dev *pdev)
 	return devres_get(&pdev->dev, new_dr, NULL, NULL);
 }
 
-static struct pci_devres * find_pci_dr(struct pci_dev *pdev)
+static struct pci_devres *find_pci_dr(struct pci_dev *pdev)
 {
 	if (pci_is_managed(pdev))
 		return devres_find(&pdev->dev, pcim_release, NULL, NULL);
-- 
1.9.1

