Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaILGzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:55:32 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19874 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaILGyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:54:19 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-31-54129899e256
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v6 6/8] power: max17040: Add ID for MAX77836 Fuel Gauge block
Date: Fri, 12 Sep 2014 08:53:58 +0200
Message-id: <1410504840-23543-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410504840-23543-1-git-send-email-k.kozlowski@samsung.com>
References: <1410504840-23543-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xy7ozZwiFGJz5qGIxZ/0aNouNM9az
	Wkx9+ITNYtKT98wW84+cY7WYuHIys0X/m4WsFuderWS0eP3C0OJs0xt2i/tfjzJafLvSwWSx
	+XsHm8XlXXPYLD73HmG0WHvkLrvF0usXmSwmTF/LYtG69wi7xeluVovTu0scRD3WzFvD6HG5
	r5fJY+esu+weK5d/YfPYvELLY9OqTjaPO9f2sHmcmPGbxWPeyUCPvi2rGD0+b5IL4I7isklJ
	zcksSy3St0vgylg39SlbQR9HxcVFa5gaGD+ydTFyckgImEh03Oxjh7DFJC7cWw8U5+IQEljK
	KPFxSQMLhNPHJLG26yETSBWbgLHE5uVLwLpFBBYwSVxclwtSxCwwlUVi0soWsFHCAr4SU/8c
	ZQaxWQRUJW7N38YCYvMKuEtMe9LKBLFOTuLkscmsIDangIfErstLweqFgGo2bWlmmsDIu4CR
	YRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSFx82cG4+JjVIUYBDkYlHl6Oc4IhQqyJZcWV
	uYcYJTiYlUR4U6cKhQjxpiRWVqUW5ccXleakFh9iZOLglGpgbJRb1PLvRYaR+ombW2f949zQ
	Le77VexbhsTkoEOB1xbeucSvlNLQxv1F+wG/99Tjfi/OKu/YMJHDxz9igXnOtb8np8xepmp+
	Lvh84DXuwPBF6wIXX10y6aDl5vrHO8U6Fh/6NjtAJ2ZlrPT/7ltbrwnr+77tk8+2tulY9Exv
	5kbvGa+7DRdan1diKc5INNRiLipOBACsWnbQaQIAAA==
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

