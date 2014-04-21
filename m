Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaDUMDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:03:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25602 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaDUMCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:02:21 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-79-535508cbd743
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 5/9] extcon: max14577: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Mon, 21 Apr 2014 21:02:18 +0900
Message-id: <1398081742-24277-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSqHuaIzTY4PU+fYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+PbloXsBV84KjZftG5gPMDexcjJ
	ISFgInF++QFWCFtM4sK99WxdjFwcQgJLGSVOrp3IBlN08vI0dojEIkaJ/vkrWSCcJiaJmXN+
	MYJUsQloSex/cQOsQ0RAQWJz7zNWkCJmgWeMEieunmAGSQgLhEm82rIeyObgYBFQlWhZ4gUS
	5hVwldj9eRsTxDY5iQ97HrGDlHAKuElcOFEOEhYCKnn0ezMjyEgJgW3sEs/XHwHbyyIgIPFt
	8iEWkHoJAVmJTQeYIcZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxiB
	cXD637O+HYw3D1gfYkwGGjeRWUo0OR8YR3kl8YbGZkYWpiamxkbmlmakCSuJ8y56mBQkJJCe
	WJKanZpakFoUX1Sak1p8iJGJg1OqgVFm3dq7DOlvHnR+/cxU0cIaW1n66dBCM1ePRMs8huMs
	b6+XcVZOVJbP47m74qF0RdwTh3n/j7+Mu8J31Ea7/od1TG7wT2UjMR+5j05PEvYsFP8z/cmD
	LV/Cj9Zvc3Ioucu+IluRNa4if0kb77zDYrNSztgeUha32Jvzft0+jfmX+Ded52bdfkaJpTgj
	0VCLuag4EQCvQQmtmQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jAd3THKHBBs9naVgcvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzvm1ZyF7whaNi80XrBsYD7F2MnBwSAiYSJy9Pg7LFJC7cW8/WxcjFISSwiFGif/5KFgin
	iUli5pxfjCBVbAJaEvtf3GADsUUEFCQ29z5jBSliFnjGKHHi6glmkISwQJjEqy3rgWwODhYB
	VYmWJV4gYV4BV4ndn7cxQWyTk/iw5xE7SAmngJvEhRPlIGEhoJJHvzczTmDkXcDIsIpRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjOMqeSe9gXNVgcYhRgINRiYf3RX5IsBBrYllxZe4hRgkO
	ZiUR3oj1QCHelMTKqtSi/Pii0pzU4kOMyUA3TWSWEk3OByaAvJJ4Q2MTMyNLI3NDCyNjc9KE
	lcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgnCETP8Vlvaf1+21TxRKkrt9/mvTEKeebYeMD
	s4U3jG/c2WIT8PlO+fymP5vm16+bNVf4xYb0W+zCrA9OiR2w+/To2pS7/O4bwpfOPFSY4x2v
	HmUTkiv/apeDD+PlsJ/u532zg1Xe/k1mK+1rKhffNO+bnPBkr0VNoiodc4OZdVZ/CZ0mfrrv
	nBJLcUaioRZzUXEiAPaTgOj2AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max14577.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 7221b32..3d24dae 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -668,13 +668,14 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize extcon device */
-	info->edev = devm_kzalloc(&pdev->dev, sizeof(*info->edev), GFP_KERNEL);
+	info->edev = devm_extcon_dev_allocate(&pdev->dev,
+					      max14577_extcon_cable);
 	if (!info->edev) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		return -ENOMEM;
 	}
 	info->edev->name = DEV_NAME;
-	info->edev->supported_cable = max14577_extcon_cable;
+
 	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-- 
1.8.0

