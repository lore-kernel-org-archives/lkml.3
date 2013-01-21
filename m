Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3AUMFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:05:11 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:65184 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3AUME7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:59 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 20/24] ab8500-fg: Use correct battery charge full design
Date: Mon, 21 Jan 2013 12:03:56 +0000
Message-Id: <1358769840-4763-21-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>

If battery is not identified while fg probe, mah_max_design gets
initialized with unknown battery's charge full design. Reinitialize
mah_max_design if battery is identified after fg probe.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Reviewed-by: Vijaya Kumar K-1 <vijay.kilari@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Olivier CLERGEAUD <olivier.clergeaud@stericsson.com>
Reviewed-by: Arun MURTHY <arun.murthy@stericsson.com>
Reviewed-by: Rabin VINCENT <rabin.vincent@stericsson.com>
Tested-by: Rupesh KUMAR <rupesh.kumar@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_fg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 1a78116..0780b60 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2090,7 +2090,8 @@ static int ab8500_fg_get_ext_psy_data(struct device *dev, void *data)
 		case POWER_SUPPLY_PROP_TECHNOLOGY:
 			switch (ext->type) {
 			case POWER_SUPPLY_TYPE_BATTERY:
-				if (!di->flags.batt_id_received) {
+				if (!di->flags.batt_id_received &&
+				    di->bm->batt_id != BATTERY_UNKNOWN) {
 					const struct abx500_battery_type *b;
 
 					b = &(di->bm->bat_type[di->bm->batt_id]);
-- 
1.7.9.5

