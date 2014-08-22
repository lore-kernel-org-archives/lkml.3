Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbaHVOME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:12:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59204 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbaHVOMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:12:01 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <linux-input@vger.kernel.org>, <dmitry.torokhov@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH] input: misc: drv260x: add check for ERM mode and LRA Libraries
Date: Fri, 22 Aug 2014 09:11:36 -0500
Message-ID: <1408716696-1126-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a check to ensure that LRA libraries are not mixed with
the ERM mode.

If ERM mode and the Library is empty "OR" the
LRA library then exit.

As the LRA and empty libraries are not applicable for
the ERM actuator.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 drivers/input/misc/drv260x.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/input/misc/drv260x.c b/drivers/input/misc/drv260x.c
index a7a19e6..d6a26a7 100644
--- a/drivers/input/misc/drv260x.c
+++ b/drivers/input/misc/drv260x.c
@@ -564,6 +564,14 @@ static int drv260x_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
+	if (haptics->mode == DRV260X_ERM_MODE &&
+	    haptics->library == DRV260X_LIB_EMPTY ||
+	    haptics->library == DRV260X_LIB_LRA) {
+		dev_err(&client->dev,
+			"ERM Mode with LRA Library mismatch\n");
+		return -EINVAL;
+	}
+
 	haptics->regulator = devm_regulator_get(&client->dev, "vbat");
 	if (IS_ERR(haptics->regulator)) {
 		error = PTR_ERR(haptics->regulator);
-- 
1.7.9.5

