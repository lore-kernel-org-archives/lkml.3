Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaDINUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:20:33 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15738 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978AbaDINU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:20:27 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-9b-53454918374e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 3/4] extcon: max8997: Fix NULL pointer exception on missing
 pdata
Date: Wed, 09 Apr 2014 15:20:14 +0200
Message-id: <1397049615-13130-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397049615-13130-1-git-send-email-k.kozlowski@samsung.com>
References: <1397049615-13130-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xy7oSnq7BBgfPmVpc//Kc1eL1C0OL
	y7vmsFncblzBZrFg4yNGB1aPvi2rGD0+b5ILYIrisklJzcksSy3St0vgyvj19gJ7wWK2is0d
	G1kaGBezdjFyckgImEjcvHKPBcIWk7hwbz1bFyMXh5DAUkaJsxf2MUM4fUwSu6ZuZAepYhMw
	lti8fAkbiC0iUCjxZMNVMJtZwFPi3d+HYDXCAsESpyZ+BouzCKhKXH4/nxnE5hVwl1ixoxtq
	m4LEsi9rweKcAh4Sk/+tBOsVAqppXtDMNIGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT8
	3E2MkBD5soNx8TGrQ4wCHIxKPLwKli7BQqyJZcWVuYcYJTiYlUR42wxcg4V4UxIrq1KL8uOL
	SnNSiw8xMnFwSjUw1ntEeU4o2px4bc4ZSadgmUvMO7epztmd7nvT/QXbk3t+H9L+5dReW6ra
	3FyYqxj3+7rFqQVRsz9EtSmsXbSioKJqhVXMXisFSbP5ky9ds9D4v+tn6e64zXX3Ym997bzD
	sXiacc6z0w8mtP2pEp/e0zNhrtbklHUqOZl1vTo7FjPKVU78O/ucgBJLcUaioRZzUXEiAHrX
	qgrvAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix NULL pointer exception when platform data is not supplied. The
driver dereferenced pdata pointer where it could be NULL.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: <stable@vger.kernel.org>
Fixes: 810d601f07c
---
 drivers/extcon/extcon-max8997.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 6a00464658c5..5e1b88cecb76 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -715,7 +715,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	if (pdata->muic_pdata) {
+	if (pdata && pdata->muic_pdata) {
 		struct max8997_muic_platform_data *muic_pdata
 			= pdata->muic_pdata;
 
-- 
1.8.3.2

