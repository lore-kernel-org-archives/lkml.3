Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab3EOJxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:53:46 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54779 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab3EOJxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:53:21 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 38/39] dmaengine: ste_dma40: Fetch the number of physical channels from DT
Date: Wed, 15 May 2013 10:52:01 +0100
Message-Id: <1368611522-9984-39-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms insist on obscure physical channel availability. This
information is currently passed though platform data in internal BSP
kernels. Once those platforms land, they'll need to configure them
appropriately, so we may as well add the infrastructure.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ae462d3..4e528dd 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3482,7 +3482,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 			       struct device_node *np)
 {
 	struct stedma40_platform_data *pdata;
-	int num_memcpy = 0;
+	int num_phy = 0, num_memcpy = 0;
 	const const __be32 *list;
 
 	pdata = devm_kzalloc(&pdev->dev,
@@ -3491,6 +3491,11 @@ static int __init d40_of_probe(struct platform_device *pdev,
 	if (!pdata)
 		return -ENOMEM;
 
+	/* If absent this value will be obtained from h/w. */
+	of_property_read_u32(np, "dma-channels", &num_phy);
+	if (num_phy > 0)
+		pdata->num_of_phy_chans = num_phy;
+
 	list = of_get_property(np, "memcpy-channels", &num_memcpy);
 	num_memcpy /= sizeof(*list);
 
-- 
1.7.10.4

