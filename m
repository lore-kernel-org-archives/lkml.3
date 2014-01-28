Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbaA1MXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:23:43 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32551 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbaA1MTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:07 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-e6-52e7a03879b3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 06/18] extcon: max14577: Change extcon name instead of static
 name according to device type
Date: Tue, 28 Jan 2014 13:18:30 +0100
Message-id: <1390911522-28209-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xa7oWC54HGZzvNLKY+vAJm8X1L89Z
	LV6/MLQ42/SG3eL+16OMFt+udDBZbHp8jdXi8q45bBZrj9xlt7jduILN4nQ3qwO3x85Zd9k9
	Nq3qZPO4c20Pm8e8k4Eem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG1wVTmQoe8VRM
	fnuCsYHxPlcXIyeHhICJRMves0wQtpjEhXvr2boYuTiEBJYySnx/co8dwuljkjj8+Q8zSBWb
	gLHE5uVLwKpEBFYzSaxZMJUFJMEs0MsocXO3B4gtLJArMfnGKrCxLAKqEtc7L4PV8Aq4S/Sc
	uA3UzAG0TkFiziQbkDCngIfEq6uNYOVCQCWnjr9jmcDIu4CRYRWjaGppckFxUnqukV5xYm5x
	aV66XnJ+7iZGSCh+3cG49JjVIUYBDkYlHt4H3c+ChFgTy4orcw8xSnAwK4nwJs5+HiTEm5JY
	WZValB9fVJqTWnyIkYmDU6qBcdemXcdKfc5f7uFa8i1wpfTdN6tu9XXF8JlcqtoUOJfL78r8
	0pYnv3TtMk2dVdRTzpgILZAzO9h4OrNyYQNj4YwAJ1V+rSaPcMv/fZWv+QN2PI1ccvXLqadt
	Lpbs8S/K97koN9qJse80YbwV9q/7dPFVsfjN8oeW35PqdJ688L2sbMD1Zf63lFiKMxINtZiL
	ihMB5yxF5SMCAAA=
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

