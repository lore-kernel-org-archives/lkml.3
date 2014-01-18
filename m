Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaARTFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 14:05:30 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59562 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751494AbaARTF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 14:05:28 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Marek Vasut <marex@denx.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH v2] iio: mxs-lradc: remove useless check
Date: Sat, 18 Jan 2014 20:05:18 +0100
Message-Id: <1390071918-10622-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking the channel number is useless since mxs_lradc_read_raw() is called from
a controlled environment and the driver is responsible for filing the struct
iio_chan_spec.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 7fc66a6a6e36..d304156ca2f7 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -897,10 +897,6 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
 {
 	struct mxs_lradc *lradc = iio_priv(iio_dev);
 
-	/* Check for invalid channel */
-	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
-		return -EINVAL;
-
 	switch (m) {
 	case IIO_CHAN_INFO_RAW:
 		if (chan->type == IIO_TEMP)
-- 
1.8.3.2

