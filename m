Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3EPLRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:17:03 -0400
Received: from sauhun.de ([89.238.76.85]:56281 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab3EPLPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:39 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 31/33] arch/mips/lantiq/xway: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:59 +0200
Message-Id: <1368702961-4325-32-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 arch/mips/lantiq/xway/gptu.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/mips/lantiq/xway/gptu.c b/arch/mips/lantiq/xway/gptu.c
index 9861c86..d6a79b8 100644
--- a/arch/mips/lantiq/xway/gptu.c
+++ b/arch/mips/lantiq/xway/gptu.c
@@ -144,10 +144,6 @@ static int gptu_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Failed to get resource\n");
-		return -ENOMEM;
-	}
 
 	/* remap gptu register range */
 	gptu_membase = devm_ioremap_resource(&pdev->dev, res);
-- 
1.7.10.4

