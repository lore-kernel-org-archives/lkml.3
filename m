Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaDYAmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:42:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57252 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaDYAmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:42:37 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-16-5359af798daa
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 4/9] extcon: max77693: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Fri, 25 Apr 2014 09:42:19 +0900
Message-id: <1398386544-16295-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42JZI2JSqFu5PjLY4OlGFYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+Ptos2MBfO4K158P8jawLiEs4uR
	k0NCwESi/89sRghbTOLCvfVsXYxcHEICSxklLs66ywJTdKrjFCtEYjqjxK91e5khnCYmiXXt
	X5hAqtgEtCT2v7jBBmKLCChIbO59BtbBLPCMUeLE1RPMIAlhgTCJBevWsoPYLAKqEsdut4A1
	8Aq4SrzsbGaGWCcn8WHPI7AaTgE3iUMnesHOEAKqeXVuDhPIUAmBbewST889YIMYJCDxbfIh
	oCIOoISsxKYDUHMkJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYzAaDj9
	79nEHYz3D1gfYkwGGjeRWUo0OR8YTXkl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoSEkhPLEnN
	Tk0tSC2KLyrNSS0+xMjEwSnVwNjB66xhzf0w4ECl3dfdR3S524R3TeV6Vf1swdkLfvMkwn1b
	+e0kWm/mzlLQun/e/cUhhhamU1fPZDF0JO3JX6Zo08JR/N/ORn6h2Pdw+/OxvcdXuUmcf+G7
	U29KoGDk8fsVq2MLS9dGJDZ6LTt6suxt4daa16y/vv3f2aloOHPK+omn+JUOPFBiKc5INNRi
	LipOBADOGjYKnAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQd3K9ZHBBn/nyVocvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgz3i7azFgwj7vixfeDrA2MSzi7GDk5JARMJE51nGKFsMUkLtxbz9bFyMUhJDCdUeLXur3M
	EE4Tk8S69i9MIFVsAloS+1/cYAOxRQQUJDb3PmMFKWIWeMYoceLqCWaQhLBAmMSCdWvZQWwW
	AVWJY7dbwBp4BVwlXnY2M0Osk5P4sOcRWA2ngJvEoRO9LCC2EFDNq3NzmCYw8i5gZFjFKJpa
	kFxQnJSea6RXnJhbXJqXrpecn7uJERxrz6R3MK5qsDjEKMDBqMTDO0E2MliINbGsuDL3EKME
	B7OSCK/yKqAQb0piZVVqUX58UWlOavEhxmSgqyYyS4km5wPTQF5JvKGxiZmRpZG5oYWRsTlp
	wkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MPbMj5o+4+2/pd03k77uC5wS4n9M7fVitUkH
	A9/yes0w3+C674C0WsZEbm9vgd1FSrt3/dG436Ll9uF/1OSCald3h6+X13awuasy20bst5ut
	xm05dZ+bzNpyo9Z7/M6cL15Zmf9K/HvchLNd/OKMlBJjBy7960sOf/3gfD9hJhuTZ7nFwjPm
	C5RYijMSDbWYi4oTAbhobKD5AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index f0f18e2..2c7c3e1 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1175,23 +1175,22 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize extcon device */
-	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
-				  GFP_KERNEL);
-	if (!info->edev) {
+	info->edev = devm_extcon_dev_allocate(&pdev->dev,
+					      max77693_extcon_cable);
+	if (IS_ERR(info->edev)) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		ret = -ENOMEM;
 		goto err_irq;
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
-	info->edev->supported_cable = max77693_extcon_cable;
+
 	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		goto err_irq;
 	}
 
-
 	/* Initialize MUIC register by using platform data or default data */
 	if (pdata && pdata->muic_data) {
 		init_data = pdata->muic_data->init_data;
-- 
1.8.0

