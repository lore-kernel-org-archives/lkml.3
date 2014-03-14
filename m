Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbaCNRdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:33:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51533 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbaCNRd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:33:29 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-57-53233d68e184
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ata: pata_imx: fix devm_ioremap_resource() return value
 checking
Date: Fri, 14 Mar 2014 18:33:13 +0100
Message-id: <2050303.yEm1sTq1hQ@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jQd0MW+Vgg5+rJC1WTd3JYrHp8TVW
	i2M7HjFZXN41h83i6bolzBa/lh9ldGDz2LSqk83jzrU9bB6bl9R79P818Pi8SS6ANYrLJiU1
	J7MstUjfLoErY+qVQywF09grvjR1MTUwdrB1MXJySAiYSMy4+58dwhaTuHBvPVCci0NIYDqj
	xNepi5ggnBYmid7GKUwgVWwCVhIT21cxgtgiArISV6Y9ZAQpYhZYyyix5cUB1i5GDg5hgWCJ
	2e3eIDUsAqoSH5p7wbbxCmhK7L2+GGybqICnxI7tK6HighI/Jt9jAbGZBeQl9u2fygpha0ms
	33mcaQIj3ywkZbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCgPpPewbiq
	weIQowAHoxIP7wUl5WAh1sSy4srcQ4wSHMxKIrz7jYFCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
	eQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGBerlTZznjrDYNA9xaR9kvn7OecvvhDazC5QzJwu
	y52nd/usZxvH1ZWzb7Xc76sIfqWjFXNu819Tq78WKvrPs1R9Zium/Dgyc3rQKbGpx7YqfuBl
	V+ja37Zrd77LiijDX40eNzKX3V/y3yr079NyTn+br3WLxB5uMYvNMw07XPCiI+/kkcio5Uos
	xRmJhlrMRcWJAJbG2cVQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource() returns a pointer to the remapped memory or
an ERR_PTR() encoded error code on failure.  Fix the check inside
pata_imx_probe() accordingly.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
Compile tested only.

 drivers/ata/pata_imx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_imx.c
===================================================================
--- a/drivers/ata/pata_imx.c	2014-03-14 16:45:04.260724378 +0100
+++ b/drivers/ata/pata_imx.c	2014-03-14 18:23:38.664623530 +0100
@@ -133,8 +133,8 @@ static int pata_imx_probe(struct platfor
 
 	io_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->host_regs = devm_ioremap_resource(&pdev->dev, io_res);
-	if (!priv->host_regs) {
-		ret = -EBUSY;
+	if (IS_ERR(priv->host_regs)) {
+		ret = PTR_ERR(priv->host_regs);
 		goto err;
 	}
 

