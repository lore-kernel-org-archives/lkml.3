Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbbALNra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:47:30 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48749 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbbALNr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:47:29 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 1/2] hwmon: (ina2xx) remove an unnecessary dev_get_drvdata() result check
Date: Mon, 12 Jan 2015 14:47:21 +0100
Message-Id: <1421070442-9635-2-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421070442-9635-1-git-send-email-bgolaszewski@baylibre.com>
References: <1421070442-9635-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwmon/ina2xx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index a16d6a2..ae110c5 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -370,9 +370,6 @@ static ssize_t ina226_set_interval(struct device *dev,
 	unsigned long val;
 	int status;
 
-	if (IS_ERR(data))
-		return PTR_ERR(data);
-
 	status = kstrtoul(buf, 10, &val);
 	if (status < 0)
 		return status;
-- 
2.1.3

