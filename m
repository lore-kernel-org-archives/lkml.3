Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaGIOxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:53:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51530 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaGIOxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:53:45 -0400
X-AuditID: cbfee61b-f79f86d00000144c-93-53bd5778dae9
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Cc: t.figa@samsung.com, m.szyprowski@samsung.com, sguinot@lacie.com,
        Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] hwmon: gpio-fan: Change name passed to
 hwmon_device_register_with_groups
Date: Wed, 09 Jul 2014 16:53:32 +0200
Message-id: <1404917613-4467-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHJMWRmVeSWpSXmKPExsVy+t9jAd2K8L3BBm3zjS1+vL7AZnF51xw2
	izvT9rJZrD1yl91i/RMui/UzXrM4sHmsvPyAyePBxN1sHn1bVjF6fN4kF8ASxWWTkpqTWZZa
	pG+XwJXxvu8XW8FE9or/236zNjB+Zu1i5OCQEDCRWH2rqouRE8gUk7hwbz1bFyMXh5DAIkaJ
	ptZlrBBOB5PE1JULGUEa2AQ0JVbd8wBpEBGwlri85zUjiM0skCXR+309M4gtLBAtcXfmSTCb
	RUBV4tiDi2A1vALOEo39m9kg9ipIzJlkM4GRewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT8
	3E2M4FB4Jr2DcVWDxSFGAQ5GJR5eBZ49wUKsiWXFlbmHGCU4mJVEeIXD9gYL8aYkVlalFuXH
	F5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYJw5T+LRXDO7VEcxYf9veT2V
	q3lePHvmyTPZI66u9+XZl4Kn8m8yr5mYYVnOp+uk48Owe5Ooy88JgTFX+M6/+LdSxNDqoM2E
	w6wL49NvNb7c/NDh+vro8qRTe36slQvdlpVi+GqTWdb/3Ep7RuW+iMn6etd6Tk/ex8rbnrc8
	reNH24SLkb0LzyuxFGckGmoxFxUnAgAUYF3yAQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 648cd48c9e566f53c5df30d79857e0937ae13b09 (hwmon: Do not accept
invalid name attributes) added check for "-" in the name of hwmon device.
This patch changes the name supplied by gpio-fan so that it is accepted
by hwmon.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/hwmon/gpio-fan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index ba35e4d..5acd555 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -538,7 +538,7 @@ static int gpio_fan_probe(struct platform_device *pdev)
 
 	/* Make this driver part of hwmon class. */
 	fan_data->hwmon_dev = hwmon_device_register_with_groups(&pdev->dev,
-						"gpio-fan", fan_data,
+						"gpiofan", fan_data,
 						gpio_fan_groups);
 	if (IS_ERR(fan_data->hwmon_dev))
 		return PTR_ERR(fan_data->hwmon_dev);
-- 
1.7.9.5

