Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaCLO0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:26:00 -0400
Received: from gloria.sntech.de ([95.129.55.99]:44678 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbaCLOZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:25:37 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 3/3] power: gpio-charger: do not use gpio value directly
Date: Wed, 12 Mar 2014 14:48:56 +0100
Message-ID: <2723546.irh9ZUoKUN@phil>
User-Agent: KMail/4.11.5 (Linux/3.12-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <12569216.pGctOhkhxz@phil>
References: <12569216.pGctOhkhxz@phil>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@bq.com>

Some gpio implementations return interesting values for gpio_get_value when
the value is not 0 - as seen on a imx6sl board. Therefore do not use the
value returned from gpio_get_value directly but simply check for 0 or not 0.

Signed-off-by: Heiko Stuebner <heiko.stuebner@bq.com>
---
 drivers/power/gpio-charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 64d31a8..e665993 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -57,7 +57,7 @@ static int gpio_charger_get_property(struct power_supply *psy,
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
-		val->intval = gpio_get_value_cansleep(pdata->gpio);
+		val->intval = gpio_get_value_cansleep(pdata->gpio) ? 1 : 0;
 		val->intval ^= pdata->gpio_active_low;
 		break;
 	default:
-- 
1.8.5.3


