Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab3FQJWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:22:30 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:35577 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab3FQJW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:22:28 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: thierry.reding@gmail.com, patches@linaro.org, sachin.kamat@linaro.org,
        sparclinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH V2 1/15] sparc,leon: Convert to use devm_ioremap_resource
Date: Mon, 17 Jun 2013 14:37:44 +0530
Message-Id: <1371460064-19549-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370864113-17895-2-git-send-email-tushar.behera@linaro.org>
References: <1370864113-17895-2-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
introduced devm_ioremap_resource() and deprecated the use of
devm_request_and_ioremap().

While at it, also remove the error message as devm_ioremap_resource()
also prints similar error message.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: sparclinux@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>
---
Changes for V2:
* Removed redundant error message.

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
1.7.9.5

