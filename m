Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbaDXMnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:43:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45064 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaDXMe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:34:59 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-fb-535904f0cb16
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 5/9] extcon: max14577: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Thu, 24 Apr 2014 21:34:53 +0900
Message-id: <1398342897-23670-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSqPuBJTLY4MokcYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK2PCWrOC/ZwVE8+uYG1gbOboYuTk
	kBAwkXh+cQU7hC0mceHeerYuRi4OIYGljBKL2/8wdzFygBXtXukAEZ/OKDH3/Ft2CKeJSWLf
	pv+sIN1sAloS+1/cYAOxRQQUJDb3PmMFKWIWeMYoceLqCWaQhLBAmMSvSY8ZQWwWAVWJq++m
	gtm8Aq4Sa481MEKcISfxYc8jsJM4Bdwkzl64CjZUCKhmZcM/sKESAvvYJf78nMgEMUhA4tvk
	QywQp8pKbDrADDFHUuLgihssExiFFzAyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIjITT
	/55N3MF4/4D1IcZkoHETmaVEk/OBkZRXEm9obGZkYWpiamxkbmlGmrCSOG/6o6QgIYH0xJLU
	7NTUgtSi+KLSnNTiQ4xMHJxSDYzJ/Z/jLtlp32C9mVTxasFG060bBW6LNJzdtWdG7KUqD+Ye
	sZoOtYOmLZe2CstPrWV563Plou6m3GtGuTMERJgDnbk7HoitWT1rttxrrn8OG+K79x2IEVh8
	TbKt5ZjZC673hZ6agpKLHzjq1F6b+e3ll+nin989Lv5Q8VHa64PQ4wdlqx39jd8osRRnJBpq
	MRcVJwIAsAYK6poCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd0PLJHBBlfXC1gcvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzJqw1K9jPWTHx7ArWBsZmji5GDg4JAROJ3Ssduhg5gUwxiQv31rN1MXJxCAlMZ5SYe/4t
	O4TTxCSxb9N/VpAqNgEtif0vbrCB2CICChKbe5+xghQxCzxjlDhx9QQzSEJYIEzi16THjCA2
	i4CqxNV3U8FsXgFXibXHGhgh1slJfNjziB3E5hRwkzh74SrYUCGgmpUN/1gnMPIuYGRYxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREcZ8+kdzCuarA4xCjAwajEw6twKzxYiDWxrLgy9xCj
	BAezkgjv7H8RwUK8KYmVValF+fFFpTmpxYcYk4GumsgsJZqcD0wBeSXxhsYmZkaWRuaGFkbG
	5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAKHn5EtOh9xyb1ec8bWfQPrsjQ/W4muq7
	5q8dkxZ29Wv8FnZNab50ZSk7/5k3TmWTH0zgXcyYH+XG/+9h4UNv+c3/jj8qdmWyflxqeVeD
	NWv+/S9bt4TM3BvHfuCB+j3Ll39qfVO8VY81ZUd9++m44uZ0wb+b/4lcXSfzWNDxU+LDLTeP
	J8meSFViKc5INNRiLipOBADIt36K9wIAAA==
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
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max14577.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index d17dd4f..7d4aa5a 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -739,14 +739,15 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize extcon device */
-	info->edev = devm_kzalloc(&pdev->dev, sizeof(*info->edev), GFP_KERNEL);
+	info->edev = devm_extcon_dev_allocate(&pdev->dev,
+					      max14577_extcon_cable);
 	if (!info->edev) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		return -ENOMEM;
 	}
 
 	info->edev->name = dev_name(&pdev->dev);
-	info->edev->supported_cable = max14577_extcon_cable;
+
 	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-- 
1.8.0

