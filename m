Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbaCTNpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:45:32 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:52102 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307AbaCTNp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:45:27 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Fugang Duan <B38611@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jingoo Han <jg1.han@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Budig <simon.budig@kernelconcepts.de>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Daniel Wagener <daniel.wagener@kernelconcepts.de>
Subject: [PATCHv5 3/5] Input: edt-ft5x06: Adjust delays to conform datasheet
Date: Thu, 20 Mar 2014 14:44:33 +0100
Message-Id: <1395323075-12146-4-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395323075-12146-1-git-send-email-LW@KARO-electronics.de>
References: <1395234563-11034-1-git-send-email-LW@KARO-electronics.de>
 <1395323075-12146-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FT5x06 datasheet specifies a minimum reset width of 5ms and a
delay between deassertion of reset and start of reporting of 300ms.
Adjust the delays to conform to the datasheet.

With the original delays I sometimes experienced communication
timeouts when initializing the controller.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/input/touchscreen/edt-ft5x06.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index 03dab2f..0298568 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -635,7 +635,7 @@ static int edt_ft5x06_ts_reset(struct i2c_client *client,
 			return error;
 		}
 
-		mdelay(5);
+		msleep(5);
 		gpio_set_value(tsdata->wake_pin, 1);
 	}
 	if (gpio_is_valid(tsdata->reset_pin)) {
@@ -650,9 +650,9 @@ static int edt_ft5x06_ts_reset(struct i2c_client *client,
 			return error;
 		}
 
-		mdelay(50);
+		msleep(5);
 		gpio_set_value(tsdata->reset_pin, 1);
-		mdelay(100);
+		msleep(300);
 	}
 
 	return 0;
-- 
1.7.10.4

