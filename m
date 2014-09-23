Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaIWLns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:43:48 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61055 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaIWLnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:43:42 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-a2-54215ce9e5de
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v7 6/8] power: max17040: Add ID for MAX77836 Fuel Gauge block
Date: Tue, 23 Sep 2014 13:43:21 +0200
Message-id: <1411472603-11821-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1411472603-11821-1-git-send-email-k.kozlowski@samsung.com>
References: <1411472603-11821-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xy7ovYxRDDKY/0LKYs34Nm8XGGetZ
	LaY+fMJmMenJe2aL+UfOsVpMXDmZ2aL/zUJWi3OvVjJavH5haHG26Q27xf2vRxktvl3pYLLY
	/L2DzeLyrjlsFp97jzBarD1yl91i6fWLTBYTpq9lsWjde4Td4nQ3q8Xp3SUOoh5r5q1h9Ljc
	18vksXPWXXaPlcu/sHlsXqHlsWlVJ5vHnWt72DxOzPjN4jHvZKBH35ZVjB6fN8kFcEdx2aSk
	5mSWpRbp2yVwZXz40s9YsIej4knLE/YGxlnsXYycHBICJhJrVh5lhLDFJC7cW8/WxcjFISSw
	lFHi54XtzBBOH5PEt4OfWEGq2ASMJTYvXwJWJSKwkFFi5pKV7CAOs8AUVonHv1vBqoQFfCXu
	7p/GBmKzCKhKPGr6AxbnFXCX6H42kQ1in5zEyWOTgeIcHJwCHhIL9zqChIWASh7962adwMi7
	gJFhFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIXHzdwbj0mNUhRgEORiUeXo81CiFCrIll
	xZW5hxglOJiVRHjfhSmGCPGmJFZWpRblxxeV5qQWH2Jk4uCUamCUzPF4IW68s37G/+0GUtoB
	p14etM7NNzhgUK94/ULo3+j9G6MMb72w6WA0nO6h2Vovc+sMy8nukNKvB8t/zzc+aPJCrtDn
	nJvvncUTcjQvTlvle/+2t1S2EufHMxoHDynLZphUF8zNk58zf93+p0ez7VgD4owbXGWylk1M
	qDK3ELhsJ/JyTa4SS3FGoqEWc1FxIgBY1mUGaQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77836 has the same Fuel Gauge as MAX17040/17048. The max17040 driver
can be safely re-used. The patch adds MAX77836 device to the array of
i2c_device_id. Additionally it removes the id associated with MAX17040
device as the value is not used.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/power/max17040_battery.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 0fbac861080d..14d44706327b 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -277,7 +277,8 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
 #endif /* CONFIG_PM_SLEEP */
 
 static const struct i2c_device_id max17040_id[] = {
-	{ "max17040", 0 },
+	{ "max17040" },
+	{ "max77836-battery" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max17040_id);
-- 
1.9.1

