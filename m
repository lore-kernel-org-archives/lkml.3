Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3JBKYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:24:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35111 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753207Ab3JBKYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:24:33 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] bq2415x_charger: fix max battery regulation voltage
Date: Wed,  2 Oct 2013 12:24:22 +0200
Message-Id: <1380709462-860-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the datasheets, maximum battery regulation voltage is 4440mV.

The formula is (voltage - offset) / step, so the maximum value is:
(4440 - 3500) / 20 = 47

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/power/bq2415x_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 0727f92..0aa643e 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -607,7 +607,7 @@ static int bq2415x_set_battery_regulation_voltage(struct bq2415x_device *bq,
 
 	if (val < 0)
 		val = 0;
-	else if (val > 94) /* FIXME: Max is 94 or 122 ? Set max value ? */
+	else if (val > 47)
 		return -EINVAL;
 
 	return bq2415x_i2c_write_mask(bq, BQ2415X_REG_VOLTAGE, val,
-- 
1.8.1.2

