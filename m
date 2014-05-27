Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaE0G3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:29:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22275 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaE0G3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:29:19 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-a7-538430be6057
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        "'Antoine Tenart'" <antoine.tenart@free-electrons.com>,
        "'Sebastian Hesselbarth'" <sebastian.hesselbarth@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] pinctrl: berlin: Use devm_ioremap_resource()
Date: Tue, 27 May 2014 15:29:17 +0900
Message-id: <000a01cf7974$fc9fc4d0$f5df4e70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac95dPx38fZTFJ+WTWaSP0ITzLT3yg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zfd19Bi3BBrensVrsWPGf1eLywkus
	FlP+LGeyuLxrDpvF+5+ODqweTzZdZPTYOesuu8eda3vYPPq2rGL0+LxJLoA1issmJTUnsyy1
	SN8ugStj8udzTAV3BCtW9Oxlb2CcxN/FyMkhIWAi8XTnc3YIW0ziwr31bF2MXBxCAssYJc7s
	2c4EU3RozWVmiMQiRokHB25BOb8ZJaYsPc0MUsUmoCbx5cthsFEiAnoSb762sIMUMQvsZpTY
	03SADSQhLGAr8ffESZYuRg4OFgFViQ0HhEDCvEDhre+OskPYghI/Jt9jAbGZBbQk1u88zgRh
	y0tsXvOWGaRVQkBd4tFfXZhVly5PYoQoEZHY9+IdI8haCYFj7BLPV30Am8MiICDxbfIhFohe
	WYlNB5ghHpOUOLjiBssERrFZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IVK84Mbe4NC9d
	Lzk/dxMjJPIm7mC8f8D6EGMy0PqJzFKiyfnAyM0riTc0NjOyMDUxNTYytzQjTVhJnDf9UVKQ
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsZI7re6pX++cq3SP/igiGXFlKCN2ZuF1WLEOdvn
	7Nh7vWOm2laXh4/EFd4LCTTFnjPhj0o3Djj2VWrZkr7aH9nbMgKX5a1pmLC3g+fyN4OYI3Gi
	tXWnl/lHzok0DWHKWXFxt9UCk3/b6jXTrXUj38neb9heGRHjcG3j1tnP7004t+BiAttr4TQl
	luKMREMt5qLiRACYX2TV0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd19Bi3BBk9XMlrsWPGf1eLywkus
	FlP+LGeyuLxrDpvF+5+ODqweTzZdZPTYOesuu8eda3vYPPq2rGL0+LxJLoA1qoHRJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdouZJCWWJOKVAoILG4
	WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY/Lnc0wFdwQrVvTsZW9gnMTfxcjJISFgInFo
	zWVmCFtM4sK99WxdjFwcQgKLGCUeHLjFDOH8ZpSYsvQ0WBWbgJrEly+H2UFsEQE9iTdfW9hB
	ipgFdjNK7Gk6wAaSEBawlfh74iRLFyMHB4uAqsSGA0IgYV6g8NZ3R9khbEGJH5PvsYDYzAJa
	Eut3HmeCsOUlNq95ywzSKiGgLvHory7MqkuXJzFClIhI7HvxjnECo8AsJJNmIZk0C8mkWUha
	FjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjutn0jsYVzVYHGIU4GBU4uGd4NscLMSa
	WFZcmXuIUYKDWUmEN5apJViINyWxsiq1KD++qDQntfgQYzLQnxOZpUST84EpJ68k3tDYxMzI
	0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGKVOp9moXl1n9HjGrVPnhKQT
	q9/yiAVO+8MhsqNyf4vu/94c27hiY4PN7/bGPt2weJae1cHOfPWVt62+cB5f9OPIjE6Rpms/
	E15ErdinFajRaBe6IvZ0lMz93TeljRJKP7KfD2iq5W/0OSPfO+Ufx7Nan/9nVQ/zPjp+KmPr
	sy3b/0fU7y7+Ka/EUpyRaKjFXFScCABNc6I8LwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() because devm_request_and_ioremap() is
obsoleted by devm_ioremap_resource().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pinctrl/berlin/berlin-bg2.c   |    6 +++---
 drivers/pinctrl/berlin/berlin-bg2cd.c |    6 +++---
 drivers/pinctrl/berlin/berlin-bg2q.c  |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/berlin/berlin-bg2.c b/drivers/pinctrl/berlin/berlin-bg2.c
index 0d8fd50..dcd4f6a 100644
--- a/drivers/pinctrl/berlin/berlin-bg2.c
+++ b/drivers/pinctrl/berlin/berlin-bg2.c
@@ -243,9 +243,9 @@ static int berlin2_pinctrl_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base)
-		return -EADDRNOTAVAIL;
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	rmconfig->reg_bits = 32,
 	rmconfig->val_bits = 32,
diff --git a/drivers/pinctrl/berlin/berlin-bg2cd.c b/drivers/pinctrl/berlin/berlin-bg2cd.c
index e095a5d..89d585e 100644
--- a/drivers/pinctrl/berlin/berlin-bg2cd.c
+++ b/drivers/pinctrl/berlin/berlin-bg2cd.c
@@ -186,9 +186,9 @@ static int berlin2cd_pinctrl_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base)
-		return -EADDRNOTAVAIL;
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	rmconfig->reg_bits = 32,
 	rmconfig->val_bits = 32,
diff --git a/drivers/pinctrl/berlin/berlin-bg2q.c b/drivers/pinctrl/berlin/berlin-bg2q.c
index ab33a3b..9fcf983 100644
--- a/drivers/pinctrl/berlin/berlin-bg2q.c
+++ b/drivers/pinctrl/berlin/berlin-bg2q.c
@@ -405,9 +405,9 @@ static int berlin2q_pinctrl_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base)
-		return -EADDRNOTAVAIL;
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	rmconfig->reg_bits = 32,
 	rmconfig->val_bits = 32,
-- 
1.7.10.4


