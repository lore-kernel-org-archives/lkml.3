Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935158AbaH0PVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:21:15 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42777 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935095AbaH0PU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:20:29 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-e9-53fdf73bda35
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
Subject: [PATCH v4 6/8] power: max17040: Add ID for MAX77836 Fuel Gauge block
Date: Wed, 27 Aug 2014 17:20:12 +0200
Message-id: <1409152814-17302-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t/xy7rW3/8GG8w7IWuxccZ6VoupD5+w
	WUx68p7ZYuLKycwW/W8Wslqce7WS0eL1C0OLs01v2C3ufz3KaPHtSgeTxebvHWwWl3fNYbP4
	3HuE0WLtkbvsFkuvX2SymDB9LYtF694j7Banu1ktTu8ucRD2WDNvDaPH5b5eJo+ds+6ye6xc
	/oXNY/MKLY9NqzrZPO5c28PmMe9koEffllWMHp83yQVwRXHZpKTmZJalFunbJXBlfN/znL1g
	G1vFtAUbGRsYd7F2MXJySAiYSLzcfJgRwhaTuHBvPRuILSSwlFHiendWFyMXkN3HJLHxyBaw
	BJuAscTm5UvAbBGBBUwSF9flgtjMAmeYJaau5gCxhQV8Ja7+ncQEYrMIqEpcvPyeGcTmFXCX
	eLroHAvEMjmJk8cmgx3BKeAh8bL3AlA9B9Ayd4m78/gnMPIuYGRYxSiaWppcUJyUnmukV5yY
	W1yal66XnJ+7iRES8l93MC49ZnWIUYCDUYmHV+H0n2Ah1sSy4srcQ4wSHMxKIrxlB/4GC/Gm
	JFZWpRblxxeV5qQWH2Jk4uCUamCcwS19zeX68rXNfzNSup/ol8x2fNn+et7LXTa7nYVv/Ow9
	UvPtQMnCv0lTa/P5v7T/v3dY71L9JwahW4s3fe2/LOThJh9reaKiPCxq0xuuY1HL/ZjSdlRL
	5lwTzpty1yBr9w4VbRYuO5ZPL8/5CKvt6Z2XL6CROW/JS8NPd6aa/+p0+eoQseGjEktxRqKh
	FnNRcSIAsjCEZVcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77836 has the same Fuel Gauge as MAX17040/17048. The max17040 driver
can be safely re-used. The patch adds MAX77836 ID to array of
i2c_device_id.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
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

