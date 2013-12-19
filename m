Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3LSPIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:08:13 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:35566 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3LSPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:08:11 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <amurray@embedded-bits.co.uk>,
        Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org
Subject: [PATCH 32/38] pcie: add missing put_device call
Date: Thu, 19 Dec 2013 16:06:46 +0100
Message-Id: <1387465612-3673-33-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.
Removed the kfree() as put_device will result in release_pcie_device being
called and hence the container of the device will be kfree'd.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/pci/pcie/portdrv_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 08d131f..80fb1f2 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -345,7 +345,7 @@ static int pcie_device_init(struct pci_dev *pdev, int service, int irq)
 
 	retval = device_register(device);
 	if (retval)
-		kfree(pcie);
+		put_device(device);
 	else
 		get_device(device);
 	return retval;
-- 
1.8.3.1

