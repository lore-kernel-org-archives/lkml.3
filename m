Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaCJJrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:47:07 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21916 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaCJJq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:46:59 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-34-531d8a1190f7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] regulator: max1586: Don't allocate memory for regulator_dev
 pointers
Date: Mon, 10 Mar 2014 10:46:52 +0100
Message-id: <1394444812-16086-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJMWRmVeSWpSXmKPExsVy+t/xq7qCXbLBBg9nS1tMffiEzeL1C0OL
	b1c6mCwu75rD5sDisXPWXXaPTas62Tz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr48Gdc2wF
	E9krdp6ZydzA+I+1i5GTQ0LAROLD0pNQtpjEhXvr2boYuTiEBJYySkz51cEO4fQxSfR/b2UD
	qWITMJbYvHwJmC0ikCGxed5UsG5mAUOJn+/+ADVwcAgLhEv8mJAFYrIIqEq8XO4BUsEr4C4x
	Y88pVpCwhICCxJxJNhMYuRcwMqxiFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECPH71x2MS49Z
	HWIU4GBU4uE98FYmWIg1say4MvcQowQHs5II78NW2WAh3pTEyqrUovz4otKc1OJDjEwcnFIN
	jCwWVu8eNWodq5b4Up6/LnPC7ubrkZv5D5f+m3lq566MFzNmZJZ43tELjt4ot+DOUzlFjvub
	fmS/abvk0vfCIUSIWfyMhYDFObcTL2J/FrczCc7xWrJ1U6j/750fpdzqWSdeiTqjHJaddrzp
	yNMra6+kGm/s+Nn99vIZjslsW/8sDzq+buGC+JlKLMUZiYZazEXFiQCpzUKT2QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not allocate memory for 'struct regulator_dev *' since it was removed
from state container (values returned by devm_regulator_register() are
not used outside of probe).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max1586.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index c2a40a1a9e3e..d23d0577754b 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -165,8 +165,7 @@ static int max1586_pmic_probe(struct i2c_client *client,
 	struct max1586_data *max1586;
 	int i, id;
 
-	max1586 = devm_kzalloc(&client->dev, sizeof(struct max1586_data) +
-			sizeof(struct regulator_dev *) * (MAX1586_V6 + 1),
+	max1586 = devm_kzalloc(&client->dev, sizeof(struct max1586_data),
 			GFP_KERNEL);
 	if (!max1586)
 		return -ENOMEM;
-- 
1.7.9.5

