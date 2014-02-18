Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaBRCJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:09:40 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53670 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbaBRCJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:09:37 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-pci@vger.kernel.org
Cc: horms@verge.net.au, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com, ben.dooks@codethink.co.uk,
        geert@linux-m68k.org, bhelgaas@google.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Tue, 18 Feb 2014 11:10:51 +0900
Message-Id: <20140218021051.14164.6194.sendpatchset@w520>
In-Reply-To: <20140218021041.14164.56411.sendpatchset@w520>
References: <20140218021041.14164.56411.sendpatchset@w520>
Subject: [PATCH 01/08] PCI: rcar: check platform_get_irq() return code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

The current code does not check the return from platform_get_irq()
so add an error check and return if this call does fail.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/pci/host/pci-rcar-gen2.c |    5 +++++
 1 file changed, 5 insertions(+)

--- 0001/drivers/pci/host/pci-rcar-gen2.c
+++ work/drivers/pci/host/pci-rcar-gen2.c	2014-02-13 09:41:55.000000000 +0900
@@ -308,6 +308,11 @@ static int __init rcar_pci_probe(struct
 	priv->reg = reg;
 	priv->dev = &pdev->dev;
 
+	if (priv->irq < 0) {
+		dev_err(&pdev->dev, "no valid irq found\n");
+		return priv->irq;
+	}
+
 	return rcar_pci_add_controller(priv);
 }
 
