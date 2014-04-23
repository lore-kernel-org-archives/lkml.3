Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbaDWOwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:52:39 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61558 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbaDWOvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:51:10 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-5f-5357d35a73e9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Anton Vorontsov <anton@enomsg.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH part2 4/6] power: max17040: Add ID for MAX77836 Fuel Gauge block
Date: Wed, 23 Apr 2014 16:50:38 +0200
Message-id: <1398264640-12122-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
References: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xa7pRl8ODDSaclbc4uFXTYuOM9awW
	Ux8+YbOY9OQ9s8XElZOZLV6/MLQ42/SG3eL+16OMFt+udDBZXN41h81i7ZG77Banu1kt1s94
	zeLA6zGh/xOjx85Zd9k9Nq/Q8ti0qpPN4861PWwe804GevRtWcXo8XmTXABHFJdNSmpOZllq
	kb5dAlfGi3P72Qv2slfMP/2KvYFxE1sXIyeHhICJxIqpk5ghbDGJC/fWA8W5OIQEljJKnH/V
	zgLh9DFJzNi6gx2kik3AWGLz8iVgVSIC3UwSrWt+soM4zAK9QFVXW1lBqoQFAiTezJrPAmKz
	CKhKzO2YBWbzCrhLXF79hx1in5zEyWOTgeo5ODgFPCQuP7UDCQsBlfx8M5F1AiPvAkaGVYyi
	qaXJBcVJ6bmGesWJucWleel6yfm5mxghgfplB+PiY1aHGAU4GJV4eCWWhwULsSaWFVfmHmKU
	4GBWEuFdsig8WIg3JbGyKrUoP76oNCe1+BAjEwenVAOjT4n34veJW4LnBbhsP65yMStUOsK1
	psB4teHUYLn63xdOSiYem6Cez3l1x40zGseKq7bmfxPeNWnmbcu0Cw8dFoRkymX58dXk9EVt
	OhfN/TWGMZPJ6PDR8MxFHXlLc5UnnZVduj6leuKSt/uzk5O51Z60rBGR/rx6wZWmOWkiNw0W
	1XWen26gxFKckWioxVxUnAgAzxIQ3DICAAA=
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

