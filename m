Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaBXKQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:16:53 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57218 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaBXKLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:11:17 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-d6-530b1ac0ee05
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 01/16] extcon: max14577: Change extcon name instead of
 static name according to device type
Date: Mon, 24 Feb 2014 11:10:26 +0100
Message-id: <1393236641-14977-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
References: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xy7oHpLiDDZa/YbfYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aLiSsnM1u8fmFocbYJqOL+16OMFpseX2O1uLxrDpvF2iN32S1Od7NarJ/x
	msWB12PnrLvsHptXaHlsWtXJ5nHn2h42j3knAz02L6n36NuyitHj8ya5AI4oLpuU1JzMstQi
	fbsErox/a6+wFBzmrfj+4gZTA+M27i5GTg4JAROJ21uvsEPYYhIX7q1n62Lk4hASWMoosef9
	LWYIp49J4trTFmaQKjYBY4nNy5eAVYkIbGGS6P3whRHEYRZ4zijxcdFMsFnCAgUS+7Z+ZQGx
	WQRUJTr2vwSL8wq4Szy/1craxcgBtE9BYs4kG5Awp4CHxN2WB6wgthBQybd511kmMPIuYGRY
	xSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESqF93MC49ZnWIUYCDUYmHV6KaK1iINbGsuDL3
	EKMEB7OSCK8ZL3ewEG9KYmVValF+fFFpTmrxIUYmDk6pBkbnOz+yov87yi3aMbOBNfv8mTnf
	HuvyTJgWtPjB+wuGPpJrytyvysxp6Tza3zPVnSFOQ2I3s41y5JeLU4XWXyvjXNPF2d3AdP9a
	7wfD9vDeguV8e16/d5436YfAOvVnE9IbKnRuJFmxeq9suZx656NygfyRamWWrbcv7dCeJzn1
	2+niRRp1Vx4psRRnJBpqMRcVJwIAAD251TICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

This patch use device name to make sysfs path according to device type:

max14577-muic
- /sys/class/extcon/max14577-muic/
max77836-muic
- /sys/class/extcon/max77836-muic/

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max14577.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 3846941801b8..59f084fee4f3 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -24,7 +24,6 @@
 #include <linux/mfd/max14577-private.h>
 #include <linux/extcon.h>
 
-#define	DEV_NAME			"max14577-muic"
 #define	DELAY_MS_DEFAULT		17000		/* unit: millisecond */
 
 enum max14577_muic_adc_debounce_time {
@@ -673,7 +672,8 @@ static int max14577_muic_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		return -ENOMEM;
 	}
-	info->edev->name = DEV_NAME;
+
+	info->edev->name = dev_name(&pdev->dev);
 	info->edev->supported_cable = max14577_extcon_cable;
 	ret = extcon_dev_register(info->edev);
 	if (ret) {
@@ -737,7 +737,7 @@ static int max14577_muic_remove(struct platform_device *pdev)
 
 static struct platform_driver max14577_muic_driver = {
 	.driver		= {
-		.name	= DEV_NAME,
+		.name	= "max14577-muic",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= max14577_muic_probe,
-- 
1.7.9.5

