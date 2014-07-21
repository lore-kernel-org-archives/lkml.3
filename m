Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaGUALg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 20:11:36 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49698 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751353AbaGUALe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 20:11:34 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCI / PM: Allow PCI devices to be put into D3cold during system suspend
Date: Mon, 21 Jul 2014 02:29:54 +0200
Message-ID: <3331155.XU3LgTaBr4@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Commit 448bd857d48e (PCI/PM: add PCIe runtime D3cold support) added
a check to prevent PCI devices from being put into D3cold during
system suspend without giving any particular reason (which was
overlooked during review).

Also that check causes the "freeze" sleep state to draw more power
than it can potentially, so drop the check.

Fixes: 448bd857d48e (PCI/PM: add PCIe runtime D3cold support)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pci.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-pm/drivers/pci/pci.c
===================================================================
--- linux-pm.orig/drivers/pci/pci.c
+++ linux-pm/drivers/pci/pci.c
@@ -1907,10 +1907,6 @@ int pci_prepare_to_sleep(struct pci_dev
 	if (target_state == PCI_POWER_ERROR)
 		return -EIO;
 
-	/* D3cold during system suspend/hibernate is not supported */
-	if (target_state > PCI_D3hot)
-		target_state = PCI_D3hot;
-
 	pci_enable_wake(dev, target_state, device_may_wakeup(&dev->dev));
 
 	error = pci_set_power_state(dev, target_state);

