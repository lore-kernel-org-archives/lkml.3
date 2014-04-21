Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaDUMEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:04:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25602 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaDUMCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:02:20 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-0b-535508caaaad
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, balbi@ti.com, gg@slimlogic.co.uk, kishon@ti.com,
        ckeepax@opensource.wolfsonmicro.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 3/9] extcon: max8997: Use devm_extcon_dev_allocate for
 extcon_dev
Date: Mon, 21 Apr 2014 21:02:16 +0900
Message-id: <1398081742-24277-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSrHuKIzTY4OJGdYuD9+stpj58wmbx
	b8oNdovrX56zWvRvcbF4/cLQ4sLTHjaLs01v2C0u75rDZnG7cQWbA5fHplWdbB4vJ/5m8+jb
	sorRY+qUv4wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK+P7v0NsBas4K3reXWFpYHzP3sXI
	ySEhYCJx5NkXZghbTOLCvfVsXYxcHEICSxkl2v43AyU4wIoebSmAiC9ilNj6/R4ThNPEJHHg
	+QxGkG42AS2J/S9usIHYIgIKEpt7n7GCFDELPGOUOHH1BNgKYYFQiXm/Qbo5OVgEVCVObe8B
	a+YVcJV4NmMO1BlyEh/2PGIH2cwp4CZx4UQ5SFgIqOTR782MIDMlBHaxS/w49RBqjoDEt8mH
	WCAulZXYdABqjKTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERgJp/89
	693BePuA9SHGZKBxE5mlRJPzgZGUVxJvaGxmZGFqYmpsZG5pRpqwkjhv0sOkICGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2MvccNfzk6rLJMqsuatGQP/wKfI9ocDvEBpmIBr96u+JKqul6r
	RPN2mwT/6X8HLbKffXY6cH+f6vHstIuTctqtvvHFvpAI9TmZKWz98siqWham40wmPgvuy05R
	6JVrDeiL+CbVIrzfnOPQvpvaHnaC25tkXio/DcvgNJaefulpV+1Hu4fXr0UrsRRnJBpqMRcV
	JwIAMjH9DpoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd1THKHBBhuvylscvF9vMfXhEzaL
	f1NusFtc//Kc1aJ/i4vF6xeGFhee9rBZnG16w25xedccNovbjSvYHLg8Nq3qZPN4OfE3m0ff
	llWMHlOn/GX0OH5jO5PH501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzvv87xFawirOi590VlgbG9+xdjBwcEgImEo+2FHQxcgKZYhIX7q1n62Lk4hASWMQosfX7
	PSYIp4lJ4sDzGYwgVWwCWhL7X9xgA7FFBBQkNvc+YwUpYhZ4xihx4uoJZpCEsECoxLzfIN2c
	HCwCqhKntveANfMKuEo8mzGHGWKdnMSHPY/AruAUcJO4cKIcJCwEVPLo92bGCYy8CxgZVjGK
	phYkFxQnpeca6RUn5haX5qXrJefnbmIEx9kz6R2MqxosDjEKcDAq8fC+yA8JFmJNLCuuzD3E
	KMHBrCTCG7EeKMSbklhZlVqUH19UmpNafIgxGeioicxSosn5wBSQVxJvaGxiZmRpZG5oYWRs
	TpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MzrdcP1l/XD7rmyvHxfBNQn4Lfa5ouJR5
	JtuXPXBU8MgyVjoUm/TSM+7ppPzVYccqitpKTiy3n/X+4tUi83zxeuNFLO1fE249WbTlS/eX
	4IrlD2bl3VfIO9M/45GPwHrG6a+OvG00eelYFXDH4s6s+Ek9uZ3fuNgyP9sfKrh16NqDOVfX
	WjySUmIpzkg01GIuKk4EADpz/CD3AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use devm_extcon_dev_allocate() to simplify the memory control
of extcon device.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max8997.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 804a446..e2ee2f5 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -699,8 +699,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	}
 
 	/* External connector */
-	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
-				  GFP_KERNEL);
+	info->edev = devm_extcon_dev_allocate(&pdev->dev, max8997_extcon_cable);
 	if (!info->edev) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		ret = -ENOMEM;
@@ -708,7 +707,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
-	info->edev->supported_cable = max8997_extcon_cable;
+
 	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-- 
1.8.0

