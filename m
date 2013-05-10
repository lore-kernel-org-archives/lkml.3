Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3EJIRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:17:52 -0400
Received: from sauhun.de ([89.238.76.85]:60635 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab3EJIRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:17:50 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [RFC 40/42] arch/mips/lantiq/xway: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:25 +0200
Message-Id: <1368173847-5661-41-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 arch/mips/lantiq/xway/gptu.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/mips/lantiq/xway/gptu.c b/arch/mips/lantiq/xway/gptu.c
index 9861c86..26226f0 100644
--- a/arch/mips/lantiq/xway/gptu.c
+++ b/arch/mips/lantiq/xway/gptu.c
@@ -143,13 +143,8 @@ static int gptu_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Failed to get resource\n");
-		return -ENOMEM;
-	}
-
 	/* remap gptu register range */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	gptu_membase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(gptu_membase))
 		return PTR_ERR(gptu_membase);
-- 
1.7.10.4

