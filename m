Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3ELOB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 10:01:26 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37630 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3ELOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 10:01:24 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: davem@davemloft.net
Cc: daniel@gaisler.com, sam@ravnborg.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] arch: sparc: kernel: use devm_ioremap_resource()
Date: Sun, 12 May 2013 16:10:07 +0200
Message-Id: <1368367807-1263-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_request_and_ioremap.cocci.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 arch/sparc/kernel/leon_pci_grpci1.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/kernel/leon_pci_grpci1.c b/arch/sparc/kernel/leon_pci_grpci1.c
index 7739a54..6df26e3 100644
--- a/arch/sparc/kernel/leon_pci_grpci1.c
+++ b/arch/sparc/kernel/leon_pci_grpci1.c
@@ -536,11 +536,9 @@ static int grpci1_of_probe(struct platform_device *ofdev)
 
 	/* find device register base address */
 	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
-	regs = devm_request_and_ioremap(&ofdev->dev, res);
-	if (!regs) {
-		dev_err(&ofdev->dev, "io-regs mapping failed\n");
-		return -EADDRNOTAVAIL;
-	}
+	regs = devm_ioremap_resource(&ofdev->dev, res);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
 
 	/*
 	 * check that we're in Host Slot and that we can act as a Host Bridge
-- 
1.7.10.4

