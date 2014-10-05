Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaJEJDF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:03:05 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36079 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaJEJAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:00:03 -0400
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=" 
	<info@are.ma>
X-Google-Original-From: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
        mchehab@osg.samsung.com, hdegoede@redhat.com,
        laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
        sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
        peter.senna@gmail.com
Subject: [PATCH 02/11] tc90522 is a client
Date: Sun,  5 Oct 2014 17:59:38 +0900
Message-Id: <5bff3e029fe189f44222961dc04790d4f58a4659.1412497399.git.knightrider@are.ma>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <cover.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
In-Reply-To: <cover.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tc90522 is an I2C client functioning as a frontend
thus, it is enough to return the FE pointer.

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/dvb-frontends/tc90522.h | 41 ++++++++++++-----------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb-frontends/tc90522.h b/drivers/media/dvb-frontends/tc90522.h
index b1cbddf..c78a5b0 100644
--- a/drivers/media/dvb-frontends/tc90522.h
+++ b/drivers/media/dvb-frontends/tc90522.h
@@ -1,12 +1,12 @@
 /*
- * Toshiba TC90522 Demodulator
+ * Earthsoft PT3 demodulator frontend Toshiba TC90522XBG OFDM(ISDB-T)/8PSK(ISDB-S)
  *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -14,29 +14,16 @@
  * GNU General Public License for more details.
  */
 
-/*
- * The demod has 4 input (2xISDB-T and 2xISDB-S),
- * and provides independent sub modules for each input.
- * As the sub modules work in parallel and have the separate i2c addr's,
- * this driver treats each sub module as one demod device.
- */
-
-#ifndef TC90522_H
-#define TC90522_H
+#ifndef	__TC90522_H__
+#define	__TC90522_H__
 
-#include <linux/i2c.h>
-#include "dvb_frontend.h"
-
-/* I2C device types */
-#define TC90522_I2C_DEV_SAT "tc90522sat"
-#define TC90522_I2C_DEV_TER "tc90522ter"
+#define TC90522_DRVNAME "tc90522"
 
 struct tc90522_config {
-	/* [OUT] frontend returned by driver */
-	struct dvb_frontend *fe;
-
-	/* [OUT] tuner I2C adapter returned by driver */
-	struct i2c_adapter *tuner_i2c;
+	fe_delivery_system_t	type;	/* IN	SYS_ISDBS or SYS_ISDBT */
+	bool			pwr;	/* IN	set only once after all demods initialized */
+	struct dvb_frontend	*fe;	/* OUT	allocated frontend */
 };
 
-#endif /* TC90522_H */
+#endif
+
-- 
1.8.4.5

