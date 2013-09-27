Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab3I0OdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:33:12 -0400
Received: from smtp-out-079.synserver.de ([212.40.185.79]:1072 "EHLO
	smtp-out-079.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3I0OdE (ORCPT
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
Subject: [PATCH 3/3] staging:iio:ade7753/ade7754/ade7759: Use spi_w8r16be() instead of spi_w8r16()
Date: Fri, 27 Sep 2013 16:34:29 +0200
Message-Id: <1380292469-17347-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1380292469-17347-1-git-send-email-lars@metafoo.de>
References: <1380292469-17347-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using spi_w8r16be() will do the conversion of the result from big endian to
native endian in the helper function. This makes the code a bit smaller and also
keeps sparse happy. Fixes the following sparse warnings:

	drivers/staging/iio/meter/ade7753.c:97:29: warning: incorrect type in argument 1 (different base types)
	drivers/staging/iio/meter/ade7753.c:97:29:    expected restricted __be16 const [usertype] *p
	drivers/staging/iio/meter/ade7753.c:97:29:    got unsigned short [usertype] *val

	drivers/staging/iio/meter/ade7754.c:97:29: warning: incorrect type in argument 1 (different base types)
	drivers/staging/iio/meter/ade7754.c:97:29:    expected restricted __be16 const [usertype] *p
	drivers/staging/iio/meter/ade7754.c:97:29:    got unsigned short [usertype] *val

	drivers/staging/iio/meter/ade7759.c:97:29: warning: incorrect type in argument 1 (different base types)
	drivers/staging/iio/meter/ade7759.c:97:29:    expected restricted __be16 const [usertype] *p
	drivers/staging/iio/meter/ade7759.c:97:29:    got unsigned short [usertype] *val

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/staging/iio/meter/ade7753.c | 3 +--
 drivers/staging/iio/meter/ade7754.c | 3 +--
 drivers/staging/iio/meter/ade7759.c | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/iio/meter/ade7753.c b/drivers/staging/iio/meter/ade7753.c
index 6200335..00492ca 100644
--- a/drivers/staging/iio/meter/ade7753.c
+++ b/drivers/staging/iio/meter/ade7753.c
@@ -86,7 +86,7 @@ static int ade7753_spi_read_reg_16(struct device *dev,
 	struct ade7753_state *st = iio_priv(indio_dev);
 	ssize_t ret;
 
-	ret = spi_w8r16(st->us, ADE7753_READ_REG(reg_address));
+	ret = spi_w8r16be(st->us, ADE7753_READ_REG(reg_address));
 	if (ret < 0) {
 		dev_err(&st->us->dev, "problem when reading 16 bit register 0x%02X",
 			reg_address);
@@ -94,7 +94,6 @@ static int ade7753_spi_read_reg_16(struct device *dev,
 	}
 
 	*val = ret;
-	*val = be16_to_cpup(val);
 
 	return 0;
 }
diff --git a/drivers/staging/iio/meter/ade7754.c b/drivers/staging/iio/meter/ade7754.c
index 2e046f6..e0aa13a 100644
--- a/drivers/staging/iio/meter/ade7754.c
+++ b/drivers/staging/iio/meter/ade7754.c
@@ -86,7 +86,7 @@ static int ade7754_spi_read_reg_16(struct device *dev,
 	struct ade7754_state *st = iio_priv(indio_dev);
 	int ret;
 
-	ret = spi_w8r16(st->us, ADE7754_READ_REG(reg_address));
+	ret = spi_w8r16be(st->us, ADE7754_READ_REG(reg_address));
 	if (ret < 0) {
 		dev_err(&st->us->dev, "problem when reading 16 bit register 0x%02X",
 			reg_address);
@@ -94,7 +94,6 @@ static int ade7754_spi_read_reg_16(struct device *dev,
 	}
 
 	*val = ret;
-	*val = be16_to_cpup(val);
 
 	return 0;
 }
diff --git a/drivers/staging/iio/meter/ade7759.c b/drivers/staging/iio/meter/ade7759.c
index 145f896..ea0c9de 100644
--- a/drivers/staging/iio/meter/ade7759.c
+++ b/drivers/staging/iio/meter/ade7759.c
@@ -86,7 +86,7 @@ static int ade7759_spi_read_reg_16(struct device *dev,
 	struct ade7759_state *st = iio_priv(indio_dev);
 	int ret;
 
-	ret = spi_w8r16(st->us, ADE7759_READ_REG(reg_address));
+	ret = spi_w8r16be(st->us, ADE7759_READ_REG(reg_address));
 	if (ret < 0) {
 		dev_err(&st->us->dev, "problem when reading 16 bit register 0x%02X",
 			reg_address);
@@ -94,7 +94,6 @@ static int ade7759_spi_read_reg_16(struct device *dev,
 	}
 
 	*val = ret;
-	*val = be16_to_cpup(val);
 
 	return 0;
 }
-- 
1.8.0

