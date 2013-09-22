Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3IVIUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 04:20:30 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:63086 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3IVIUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 04:20:25 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, zubair.lutfullah@gmail.com
Subject: [PATCH 3/3] iio: ti_am335x_adc: cleanup error case
Date: Sun, 22 Sep 2013 13:20:05 +0500
Message-Id: <1379838005-15158-4-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379838005-15158-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1379838005-15158-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver is functional without this error case. Cleaned up.

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 4eb63eb..8fb5429 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -323,7 +323,6 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 	struct tiadc_device *adc_dev = iio_priv(indio_dev);
 	int i, map_val;
 	unsigned int fifo1count, read, stepid;
-	u32 step = UINT_MAX;
 	bool found = false;
 	u32 step_en;
 	unsigned long timeout = jiffies + usecs_to_jiffies
@@ -353,15 +352,6 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 	 * Hence we need to flush out this data.
 	 */
 
-	for (i = 0; i < ARRAY_SIZE(adc_dev->channel_step); i++) {
-		if (chan->channel == adc_dev->channel_line[i]) {
-			step = adc_dev->channel_step[i];
-			break;
-		}
-	}
-	if (WARN_ON_ONCE(step == UINT_MAX))
-		return -EINVAL;
-
 	fifo1count = tiadc_readl(adc_dev, REG_FIFO1CNT);
 	for (i = 0; i < fifo1count; i++) {
 		read = tiadc_readl(adc_dev, REG_FIFO1);
-- 
1.7.9.5

