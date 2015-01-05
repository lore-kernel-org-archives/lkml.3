Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbbAEPxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:53:51 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56286 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbbAEPsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:23 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ac-54aab245c078
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 07/19] mfd: ab8500: Use power_supply_*() API for
 accessing function attrs
Date: Mon, 05 Jan 2015 16:47:50 +0100
Message-id: <1420472882-10463-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xa7pum1aFGExjtJj05D2zxcSVk5kt
	Xr8wtNj58C2bxfJ9/YwWmx5fY7W4vGsOm8Xn3iOMFndPHWWzOHP6EqvF6d0lDtweO2fdZffY
	vELLY9OqTjaPzUvqPbZcbWfx6NuyitFjxerv7B6fN8kFcERx2aSk5mSWpRbp2yVwZSxZ95m1
	4AJ3xZYzb9gbGC9wdjFyckgImEi0rHvNDGGLSVy4t56ti5GLQ0hgKaPEte/bWSGcPiaJdc+n
	sINUsQkYS2xevgSsSkTgCZPE9NaTLCAJZgFDiZ/v/oAVCQskSsxcfxHI5uBgEVCVaF2oCBLm
	FXCXuLh9AhPENjmJk8cms4LYnAIeEk1/L4CNEQKq+fDsF+sERt4FjAyrGEVTS5MLipPSc430
	ihNzi0vz0vWS83M3MUJC8usOxqXHrA4xCnAwKvHwepxYGSLEmlhWXJl7iFGCg1lJhPdV+qoQ
	Id6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwc3Mxval9sOlswfRN/YuXx80VaVwsZXntJGN3PPlV1
	6JQOQ+6d6nf2bHP4eptv2P5vffR5/U52nt1ytzIfddmfvhkruVLlROMKhZCu4hnLxVaIvUhV
	lN2dERWySyk2frGF9Ln9EstMg1Zxeu47rPT9ut42rsWf+w6Kbv75pT3mjMgzZYMN0w2VWIoz
	Eg21mIuKEwG78epYJwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access in case of unregistering the power
supply (e.g. by removing the driver). Replace:
 - get_property -> power_supply_get_property

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-sysctrl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index cfff0b643f1b..d4a4b24be7c6 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -49,7 +49,8 @@ static void ab8500_power_off(void)
 		if (!psy)
 			continue;
 
-		ret = psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &val);
+		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
+				&val);
 
 		if (!ret && val.intval) {
 			charger_present = true;
@@ -63,8 +64,8 @@ static void ab8500_power_off(void)
 	/* Check if battery is known */
 	psy = power_supply_get_by_name("ab8500_btemp");
 	if (psy) {
-		ret = psy->get_property(psy, POWER_SUPPLY_PROP_TECHNOLOGY,
-					&val);
+		ret = power_supply_get_property(psy,
+				POWER_SUPPLY_PROP_TECHNOLOGY, &val);
 		if (!ret && val.intval != POWER_SUPPLY_TECHNOLOGY_UNKNOWN) {
 			printk(KERN_INFO
 			       "Charger \"%s\" is connected with known battery."
-- 
1.9.1

