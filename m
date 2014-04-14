Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaDNJRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:17:38 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61032 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaDNJRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:17:37 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-af-534ba7aecd58
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 1/9] extcon: max14577: Change extcon name instead of static
 name according to device type
Date: Mon, 14 Apr 2014 11:17:12 +0200
Message-id: <1397467040-30502-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4Fd11y72DDWbd47XYOGM9q8XUh0/Y
	LK5/ec5q8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBZrj9xlt7jduILN4nQ3qwO3x85Zd9k9
	Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlfH33BzWgn7eiuZJx1kb
	GLu4uxg5OSQETCSWzv3GBmGLSVy4tx7I5uIQEljKKPFq4hoop49JovPIGRaQKjYBY4nNy5eA
	JUQEmpkkWvrOMoI4zAJHGSWm975lAqkSFsiTWDpzPlgHi4CqROOig4wgNq+Au8Tv5XvZIfYp
	SCz7spYZxOYU8JC41X0MzBYCqnnx6Tb7BEbeBYwMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNz
	NzFCwvDrDsalx6wOMQpwMCrx8HbM8Q4WYk0sK67MPcQowcGsJMK7LcMrWIg3JbGyKrUoP76o
	NCe1+BAjEwenVAPj7W8PJ636XJC5zstb1PqIpv9/wzK5bhG+18LLDqx4b6OpuOzsyePhD37b
	sjW0LnT/cfb0mXs6W2fs3aDLt007Zs61S2f2LkhcNpHJcysLv5rLDu1ar18hmjNKb1fI71yb
	+8l6PlvSkaN70mdmHo7zCH5VfWtFxUbfGlU74z/vpL4cP5q87/iDdiWW4oxEQy3mouJEAPSS
	LfUhAgAA
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
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max14577.c | 6 +++---
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
1.8.3.2

