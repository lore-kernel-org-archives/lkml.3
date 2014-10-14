Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaJNMVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:21:14 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14505 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257AbaJNMVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:21:09 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-bd-543d1531c8ff
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Guenter Roeck <linux@roeck-us.net>,
        Pavel Machek <pavel@ucw.cz>, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 7/8] power: bq2415x_charger: Use power_supply_*() API for
 accessing function attrs
Date: Tue, 14 Oct 2014 14:20:45 +0200
Message-id: <1413289246-31650-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
References: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xq7qGorYhBqcXalkc3KppsXHGelaL
	SU/eM1tMXDmZ2aLz7BNmi9cvDC3ONr1ht7j/9SijxZQ/y5ksNj2+xmpxedccNovPvUcYLZ4s
	PMNksfbIXXaL240r2CzunjrKZnG6m9Xi9O4SByGPCf2fGD12zrrL7rF5hZbHplWdbB53ru1h
	85h3MtBj85J6j53fG9g9+rasYvRYsfo7u8fnTXIB3FFcNimpOZllqUX6dglcGSc3PmEr2Mpe
	8X7af7YGxmVsXYycHBICJhK3+y8wQ9hiEhfurQeKc3EICSxllHj2fSILhNPHJHH9zX4mkCo2
	AWOJzcuXgFWJCFxnkuhcMQGsilmgkVniXUMzWJWwQIrEn8nrGEFsFgFViddHV4Ht4BVwl3jR
	dRNqn5zEyWOTWUFsTgEPiZWLjrCA2EJANe0nb7NNYORdwMiwilE0tTS5oDgpPddIrzgxt7g0
	L10vOT93EyMk7L/uYFx6zOoQowAHoxIPb0GkTYgQa2JZcWXuIUYJDmYlEV4FDtsQId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYxME3Yot+Z/6y42/CF14djun0dSPkQLL3uzcYte8+NVdq/3u/yf
	6NkVJbY6sH1ab3dG2or+2Nvi75csT27SvrGn7VvtWh6e+Q0L6uaYzTisF8hia/2MYbXnisUC
	Vs2mQYtKmnpEvGIP2/3y8nkqtILzeBnj/H6xndzXfGJFcjWPKtQsTt1xOlyJpTgj0VCLuag4
	EQBzxjWPWQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access access in case of unregistering the power
supply (.e.g by removing the driver). Replace:
 - get_property -> power_supply_get_property

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/power/bq2415x_charger.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index d9c457217b6a..81a3a78b92d8 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -816,7 +816,8 @@ static int bq2415x_notifier_call(struct notifier_block *nb,
 
 	dev_dbg(bq->dev, "notifier call was called\n");
 
-	ret = psy->get_property(psy, POWER_SUPPLY_PROP_CURRENT_MAX, &prop);
+	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_CURRENT_MAX,
+			&prop);
 	if (ret != 0)
 		return NOTIFY_OK;
 
-- 
1.9.1

