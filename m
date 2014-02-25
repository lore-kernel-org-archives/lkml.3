Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaBYKES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:04:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37114 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaBYKEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:10 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH 1/2] regulator: dummy: Should be always-on
Date: Tue, 25 Feb 2014 11:03:46 +0100
Message-Id: <1393322627-26543-2-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393322627-26543-1-git-send-email-mpa@pengutronix.de>
References: <1393322627-26543-1-git-send-email-mpa@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulator dummy does not have any enable operations. So it is always_on.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/regulator/dummy.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/dummy.c b/drivers/regulator/dummy.c
index df9f425..2436db9 100644
--- a/drivers/regulator/dummy.c
+++ b/drivers/regulator/dummy.c
@@ -25,7 +25,11 @@
 
 struct regulator_dev *dummy_regulator_rdev;
 
-static struct regulator_init_data dummy_initdata;
+static struct regulator_init_data dummy_initdata = {
+	.constraints = {
+		.always_on = 1,
+	},
+};
 
 static struct regulator_ops dummy_ops;
 
-- 
1.8.5.3

