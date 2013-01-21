Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3AUMJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:09:56 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:63369 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3AUME3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:29 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/24] ab8500-chargalg: Update battery health on safety timer exp
Date: Mon, 21 Jan 2013 12:03:42 +0000
Message-Id: <1358769840-4763-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the charging safety timer elapses, the battery health is
shown as "Good". This is misleading and also makes it difficult
to distinguish issues relating to discharging despite the fact
that the charger is still connected.

When in actual fact a safety timer elapse is an indication of a
fault in the battery. Here we make this clearer by reporting
POWER_SUPPLY_HEALTH_UNSPEC_FAILURE instead.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/abx500_chargalg.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 830b2dd..2463fa0 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1628,6 +1628,9 @@ static int abx500_chargalg_get_property(struct power_supply *psy,
 				val->intval = POWER_SUPPLY_HEALTH_COLD;
 			else
 				val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+		} else if (di->charge_state == STATE_SAFETY_TIMER_EXPIRED ||
+			   di->charge_state == STATE_SAFETY_TIMER_EXPIRED_INIT) {
+			val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
 		} else {
 			val->intval = POWER_SUPPLY_HEALTH_GOOD;
 		}
-- 
1.7.9.5

