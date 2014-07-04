Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030185AbaGDKOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:14:48 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53276 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860AbaGDKNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:13:00 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-f5-53b67e29aa74
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [PATCH v3 4/6] power: max17040: Add ID for MAX77836 Fuel Gauge block
Date: Fri, 04 Jul 2014 12:12:43 +0200
Message-id: <1404468765-10818-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404468765-10818-1-git-send-email-k.kozlowski@samsung.com>
References: <1404468765-10818-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xK7qadduCDXr2G1oc3KppsXHGelaL
	qQ+fsFlMevKe2WLiysnMFv1vFrJanHu1ktHi9QtDi7NNb9gt7n89ymjx7UoHk8Xm7x1sFpd3
	zWGzWHvkLrvF0usXmSwmTF/LYtG69wi7xeluVgchjzXz1jB6XO7rZfKY0P+J0WPnrLvsHiuX
	f2Hz2LxCy2PTqk42jzvX9rB5zDsZ6NG3ZRWjx+dNcgHcUVw2Kak5mWWpRfp2CVwZL87tZy/Y
	y14x//Qr9gbGTWxdjJwcEgImErtf32SCsMUkLtxbDxTn4hASWMoo8WPSHEYIp49J4u+bT6wg
	VWwCxhKbly8BqxIRmMYosXjDRLAqZoE9LBKnN/8Amyss4Cvxb/9Hli5GDg4WAVWJtkXWICav
	gLvE414FiG1yEiePTQabySngIbGi7RgjiC0EVPKo5RvrBEbeBYwMqxhFU0uTC4qT0nON9IoT
	c4tL89L1kvNzNzFCwv7rDsalx6wOMQpwMCrx8L7Q3xQsxJpYVlyZe4hRgoNZSYT3bfW2YCHe
	lMTKqtSi/Pii0pzU4kOMTBycUg2MQjLzolUOshglCQSt4KlNEoreu/P2lwdiSrqCl0p8r3/M
	3sh2Lf+n4fyqufWWDnOVDk0xqLJbweGmqH+zLP/G8e3ZrAv0D3nui0xoZTvd1T15aclf4auH
	v1uffzv7HcfFwL0af4RMinqu6+5kN+zYNq1Gx91Gxqe46dJH4UtbrzMZL2y7NKdCiaU4I9FQ
	i7moOBEADE/y+lkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77836 has the same Fuel Gauge as MAX17040/17048. The max17040 driver
can be safely re-used. The patch adds MAX77836 ID to array of
i2c_device_id.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/max17040_battery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 0fbac861080d..165ffe381803 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -278,6 +278,7 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
 
 static const struct i2c_device_id max17040_id[] = {
 	{ "max17040", 0 },
+	{ "max77836-battery", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max17040_id);
-- 
1.9.1

