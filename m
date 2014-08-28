Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaH1NGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:06:19 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13912 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaH1NGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:06:14 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-ae-53ff294476ae
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
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 6/8] power: max17040: Add ID for MAX77836 Fuel Gauge block
Date: Thu, 28 Aug 2014 15:05:48 +0200
Message-id: <1409231150-2701-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409231150-2701-1-git-send-email-k.kozlowski@samsung.com>
References: <1409231150-2701-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7oumv+DDZpnclpsnLGe1WLqwyds
	FpOevGe2mLhyMrNF/5uFrBbnXq1ktHj9wtDibNMbdov7X48yWny70sFksfl7B5vF5V1z2Cw+
	9x5htFh75C67xdLrF5ksJkxfy2LRuvcIu8XpblaL07tLHIQ91sxbw+hxua+XyWPnrLvsHiuX
	f2Hz2LxCy2PTqk42jzvX9rB5zDsZ6NG3ZRWjx+dNcgFcUVw2Kak5mWWpRfp2CVwZ3ZefMhbc
	ZK84d7CPuYHxIFsXIyeHhICJxMGb+1ggbDGJC/fWA8W5OIQEljJKfFlwkBXC6WOS2L5iDytI
	FZuAscTm5UvAukUEFjBJXFyXC2IzC5xhlpi6mgPEFhbwlTj36jQziM0ioCrx+tg/sA28Am4S
	rY9/Qm2Tkzh5bDLYTE4Bd4kPTfuAbA6gZW4Sm3tCJjDyLmBkWMUomlqaXFCclJ5rpFecmFtc
	mpeul5yfu4kREvRfdzAuPWZ1iFGAg1GJh1fh9J9gIdbEsuLK3EOMEhzMSiK8myT/BwvxpiRW
	VqUW5ccXleakFh9iZOLglGpgXP3Fm/G4napJsNk1ztVPjE6suJT0V0o+lONiWOwZmUDbuPWT
	r1nXX5q8cTPD65126htU7uspc9/VFVAXVpym9PuXrHhrlU6o3qX38afrXrbKJ3KVKux4H9zO
	fyFjf+j1W0+sBZ6IB7984n91CveaPSHfAl8/SVhS2Mzca+peHnOTl0+AlfOZEktxRqKhFnNR
	cSIA7d8+NlgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77836 has the same Fuel Gauge as MAX17040/17048. The max17040 driver
can be safely re-used. The patch adds MAX77836 device to the array of
i2c_device_id. Additionally it removes the id associated with MAX17040
device as the value is not used.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
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

