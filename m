Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbbAEPvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:51:37 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57063 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbbAEPsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:25 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b1-54aab245f737
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 09/19] power: bq2415x_charger: Use power_supply_*() API
 for accessing function attrs
Date: Mon, 05 Jan 2015 16:47:52 +0100
Message-id: <1420472882-10463-10-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xa7qum1aFGEy4pm4x6cl7ZouJKycz
	W7x+YWix8+FbNovl+/oZLTY9vsZqcXnXHDaLz71HGC3unjrKZnHm9CVWi9O7Sxy4PXbOusvu
	sXmFlsemVZ1sHpuX1HtsudrO4tG3ZRWjx4rV39k9Pm+SC+CI4rJJSc3JLEst0rdL4Mo42T2V
	saCdo+LNdskGxvdsXYwcHBICJhIzL2h0MXICmWISF+6tBwpzcQgJLGWU6JrSwwLh9DFJND7b
	wARSxSZgLLF5+RKwKhGBJ0wS01tPsoAkmAUMJX6++8MOYgsL5Ehcvf4DbAOLgKrEpwZpkDCv
	gIfE0u43rBDb5CROHpsMZnMCxZv+XgAbIyTgLvHh2S/WCYy8CxgZVjGKppYmFxQnpeca6hUn
	5haX5qXrJefnbmKEBOSXHYyLj1kdYhTgYFTi4fU4sTJEiDWxrLgy9xCjBAezkgjvq/RVIUK8
	KYmVValF+fFFpTmpxYcYmTg4pRoY3e9P61Rrn5+WV+uzPT2hnefuouerwtNiX5yMXfc46tEt
	GdP6//Y8AiJKXdy1Fnm3ruwpZf0Zn/LiacaJNsGmH+xepQbm/ZdbHvIvzLrGObEzdKva8i8X
	n3srpbc/3Xym98CXs3HVTNtUI17XsLi/OPB36mk/4wmtRR+XBe2RkZK9u5xzujyDEktxRqKh
	FnNRcSIAhy2wmiYCAAA=
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
---
 drivers/power/bq2415x_charger.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 1f49986fc605..2f80de0410d9 100644
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

