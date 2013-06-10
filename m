Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3FJLuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:50:02 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48608 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab3FJLtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:49:52 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, sparclinux@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 01/15] sparc,leon: Convert to use devm_ioremap_resource
Date: Mon, 10 Jun 2013 17:04:59 +0530
Message-Id: <1370864113-17895-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: sparclinux@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>
---
* Not compile tested.
 arch/sparc/kernel/leon_pci_grpci1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/leon_pci_grpci1.c b/arch/sparc/kernel/leon_pci_grpci1.c
index 7739a54..23497f4 100644
--- a/arch/sparc/kernel/leon_pci_grpci1.c
+++ b/arch/sparc/kernel/leon_pci_grpci1.c
@@ -536,10 +536,10 @@ static int grpci1_of_probe(struct platform_device *ofdev)
 
 	/* find device register base address */
 	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
-	regs = devm_request_and_ioremap(&ofdev->dev, res);
-	if (!regs) {
+	regs = devm_ioremap_resource(&ofdev->dev, res);
+	if (IS_ERR(regs)) {
 		dev_err(&ofdev->dev, "io-regs mapping failed\n");
-		return -EADDRNOTAVAIL;
+		return PTR_ERR(regs);
 	}
 
 	/*
-- 
1.7.9.5

