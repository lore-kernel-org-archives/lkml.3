Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbaKEPKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:10:25 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42445 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755464AbaKEPKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:10:06 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/3] input: touchscreen: of: Register multitouch axes
Date: Wed,  5 Nov 2014 16:07:49 +0100
Message-Id: <1415200070-19346-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415200070-19346-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1415200070-19346-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far, the DT parsing code was only setting up the regular input axes,
completely ignoring their multitouch counter parts.

Fill them with the same parameters than the regular axes.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/input/touchscreen/of_touchscreen.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/of_touchscreen.c b/drivers/input/touchscreen/of_touchscreen.c
index 74d6b0eb50ac..cf2a753edd96 100644
--- a/drivers/input/touchscreen/of_touchscreen.c
+++ b/drivers/input/touchscreen/of_touchscreen.c
@@ -42,17 +42,23 @@ void touchscreen_parse_of_params(struct input_dev *dev)
 
 	maximum = of_get_optional_u32(np, "touchscreen-size-x");
 	fuzz = of_get_optional_u32(np, "touchscreen-fuzz-x");
-	if (maximum || fuzz)
+	if (maximum || fuzz) {
 		input_set_abs_params(dev, ABS_X, 0, maximum, fuzz, 0);
+		input_set_abs_params(dev, ABS_MT_POSITION_X, 0, maximum, fuzz, 0);
+	}
 
 	maximum = of_get_optional_u32(np, "touchscreen-size-y");
 	fuzz = of_get_optional_u32(np, "touchscreen-fuzz-y");
-	if (maximum || fuzz)
+	if (maximum || fuzz) {
 		input_set_abs_params(dev, ABS_Y, 0, maximum, fuzz, 0);
+		input_set_abs_params(dev, ABS_MT_POSITION_Y, 0, maximum, fuzz, 0);
+	}
 
 	maximum = of_get_optional_u32(np, "touchscreen-max-pressure");
 	fuzz = of_get_optional_u32(np, "touchscreen-fuzz-pressure");
-	if (maximum || fuzz)
+	if (maximum || fuzz) {
 		input_set_abs_params(dev, ABS_PRESSURE, 0, maximum, fuzz, 0);
+		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, maximum, fuzz, 0);
+	}
 }
 EXPORT_SYMBOL(touchscreen_parse_of_params);
-- 
2.1.1

