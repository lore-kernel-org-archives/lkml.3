Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaF2Jka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 05:40:30 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53132 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbaF2Jk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 05:40:29 -0400
From: Federico Di Pierro <nierro92@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Federico Di Pierro <nierro92@gmail.com>
Subject: [PATCH 1/1] staging: iio: Coding style issues fix.
Date: Sun, 29 Jun 2014 11:41:02 +0200
Message-Id: <1404034862-5789-1-git-send-email-nierro92@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some little style issues in drivers/staging/iio/frequency/ad9832.c .
This is my latest task of the eudyptula challenge (third attempt!)

Signed-off-by: Federico Di Pierro <nierro92@gmail.com>
---
 drivers/staging/iio/frequency/ad9832.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/iio/frequency/ad9832.c b/drivers/staging/iio/frequency/ad9832.c
index c7d0307..b7c8351 100644
--- a/drivers/staging/iio/frequency/ad9832.c
+++ b/drivers/staging/iio/frequency/ad9832.c
@@ -57,7 +57,7 @@ static int ad9832_write_frequency(struct ad9832_state *st,
 }
 
 static int ad9832_write_phase(struct ad9832_state *st,
-				  unsigned long addr, unsigned long phase)
+			      unsigned long addr, unsigned long phase)
 {
 	if (phase > (1 << AD9832_PHASE_BITS))
 		return -EINVAL;
@@ -72,10 +72,8 @@ static int ad9832_write_phase(struct ad9832_state *st,
 	return spi_sync(st->spi, &st->phase_msg);
 }
 
-static ssize_t ad9832_write(struct device *dev,
-		struct device_attribute *attr,
-		const char *buf,
-		size_t len)
+static ssize_t ad9832_write(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t len)
 {
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 	struct ad9832_state *st = iio_priv(indio_dev);
@@ -109,11 +107,11 @@ static ssize_t ad9832_write(struct device *dev,
 		ret = spi_sync(st->spi, &st->msg);
 		break;
 	case AD9832_FREQ_SYM:
-		if (val == 1)
+		if (val == 1) {
 			st->ctrl_fp |= AD9832_FREQ;
-		else if (val == 0)
+		} else if (val == 0) {
 			st->ctrl_fp &= ~AD9832_FREQ;
-		else {
+		} else {
 			ret = -EINVAL;
 			break;
 		}
-- 
2.0.1

