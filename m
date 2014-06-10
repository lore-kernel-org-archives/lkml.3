Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaFJJpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 05:45:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48726 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaFJJpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 05:45:13 -0400
From: Juergen Borleis <jbe@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, kernel@pengutronix.de
Subject: [PATCH 5/7] bq27xxx: suppress error messages
Date: Tue, 10 Jun 2014 11:44:51 +0200
Message-Id: <1402393493-3559-6-git-send-email-jbe@pengutronix.de>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
References: <1402393493-3559-1-git-send-email-jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:a236:9fff:fe00:814
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the support for hot-plug, the inaccessibility of the device if a regular use-case.

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
---
 drivers/power/bq27x00_battery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index a5a88f1..3f3169e 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -382,7 +382,7 @@ static int bq27x00_battery_read_pwr_avg(struct bq27x00_device_info *di, u8 reg)
 
 	tval = bq27x00_read(di, reg, false);
 	if (tval < 0) {
-		dev_err(di->dev, "error reading power avg rgister  %02x: %d\n",
+		dev_dbg(di->dev, "error reading power avg register  %02x: %d\n",
 			reg, tval);
 		return tval;
 	}
@@ -403,7 +403,7 @@ static int bq27x00_battery_read_health(struct bq27x00_device_info *di)
 
 	tval = bq27x00_read(di, BQ27x00_REG_FLAGS, false);
 	if (tval < 0) {
-		dev_err(di->dev, "error reading flag register:%d\n", tval);
+		dev_dbg(di->dev, "error reading flag register:%d\n", tval);
 		return tval;
 	}
 
-- 
2.0.0.rc2

