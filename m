Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaANL7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:59:34 -0500
Received: from sauhun.de ([89.238.76.85]:47845 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaANL70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:59:26 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 6/7] arch/mips/pci: don't check resource with devm_ioremap_resource
Date: Tue, 14 Jan 2014 12:58:57 +0100
Message-Id: <1389700739-3696-6-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---

Should go via subsystem tree

 arch/mips/pci/pci-rt3883.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/mips/pci/pci-rt3883.c b/arch/mips/pci/pci-rt3883.c
index adeff2b..72919ae 100644
--- a/arch/mips/pci/pci-rt3883.c
+++ b/arch/mips/pci/pci-rt3883.c
@@ -436,9 +436,6 @@ static int rt3883_pci_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -EINVAL;
-
 	rpc->base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(rpc->base))
 		return PTR_ERR(rpc->base);
-- 
1.8.5.1

