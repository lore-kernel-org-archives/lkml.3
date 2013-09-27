Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3I0OdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:33:09 -0400
Received: from smtp-out-079.synserver.de ([212.40.185.79]:1071 "EHLO
	smtp-out-079.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3I0OdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:33:04 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25502
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-spi@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/3] hwmon: (adt7310) Use spi_w8r16be() instead spi_w8r16()
Date: Fri, 27 Sep 2013 16:34:28 +0200
Message-Id: <1380292469-17347-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1380292469-17347-1-git-send-email-lars@metafoo.de>
References: <1380292469-17347-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using spi_w8r16be() instead of spi_w8r16() in this driver makes a code a bit
shorter and cleaner.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/hwmon/adt7310.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/hwmon/adt7310.c b/drivers/hwmon/adt7310.c
index da5f078..5994cf6 100644
--- a/drivers/hwmon/adt7310.c
+++ b/drivers/hwmon/adt7310.c
@@ -42,13 +42,8 @@ static const u8 adt7310_reg_table[] = {
 static int adt7310_spi_read_word(struct device *dev, u8 reg)
 {
 	struct spi_device *spi = to_spi_device(dev);
-	int ret;
 
-	ret = spi_w8r16(spi, AD7310_COMMAND(reg) | ADT7310_CMD_READ);
-	if (ret < 0)
-		return ret;
-
-	return be16_to_cpu((__force __be16)ret);
+	return spi_w8r16be(spi, AD7310_COMMAND(reg) | ADT7310_CMD_READ);
 }
 
 static int adt7310_spi_write_word(struct device *dev, u8 reg, u16 data)
-- 
1.8.0

