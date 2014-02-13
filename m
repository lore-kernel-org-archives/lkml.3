Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaBMDCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 22:02:04 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39767 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaBMDCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 22:02:00 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-pci@vger.kernel.org
Cc: horms@verge.net.au, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com, ben.dooks@codethink.co.uk,
        geert@linux-m68k.org, bhelgaas@google.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Thu, 13 Feb 2014 12:03:12 +0900
Message-Id: <20140213030312.10398.47163.sendpatchset@w520>
In-Reply-To: <20140213030302.10398.37322.sendpatchset@w520>
References: <20140213030302.10398.37322.sendpatchset@w520>
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
 
