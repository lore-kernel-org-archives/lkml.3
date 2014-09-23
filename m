Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbaIWUn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:43:56 -0400
Received: from gloria.sntech.de ([95.129.55.99]:57373 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593AbaIWUmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:42:40 -0400
From: Heiko Stuebner <heiko@sntech.de>
To: sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, dianders@chromium.org, heiko@sntech.de,
        Heiko Stuebner <heiko.stuebner@bq.com>
Subject: [PATCH v4 3/3] power: gpio-charger: do not use gpio value directly
Date: Tue, 23 Sep 2014 22:42:16 +0200
Message-Id: <1411504936-21026-4-git-send-email-heiko@sntech.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411504936-21026-1-git-send-email-heiko@sntech.de>
References: <1411504936-21026-1-git-send-email-heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@bq.com>

Some gpio implementations return interesting values for gpio_get_value when
the value is not 0 - as seen on a imx6sl board. Therefore do not use the
value returned from gpio_get_value directly but simply check for 0 or not 0.

Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
---
 drivers/power/gpio-charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 22f084a..7d4eab2 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -57,7 +57,7 @@ static int gpio_charger_get_property(struct power_supply *psy,
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
-		val->intval = gpio_get_value_cansleep(pdata->gpio);
+		val->intval = !!gpio_get_value_cansleep(pdata->gpio);
 		val->intval ^= pdata->gpio_active_low;
 		break;
 	default:
-- 
2.1.0

