Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3ISGZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 02:25:05 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47542 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3ISGY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 02:24:56 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk, dmitry.torokhov@gmail.com
Cc: linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, zubair.lutfullah@gmail.com
Subject: [PATCH 2/3] iio: ti_am335x_adc: optimize memory usage
Date: Thu, 19 Sep 2013 11:24:34 +0500
Message-Id: <1379571876-12420-3-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379571876-12420-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1379571876-12420-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12 bit ADC data is stored in 32 bits of storage.
Change from u32 to u16 to reduce wasted memory.

Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index a952538..ebe93eb 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -122,7 +122,7 @@ static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
 		chan->datasheet_name = chan_name_ain[chan->channel];
 		chan->scan_type.sign = 'u';
 		chan->scan_type.realbits = 12;
-		chan->scan_type.storagebits = 32;
+		chan->scan_type.storagebits = 16;
 	}
 
 	indio_dev->channels = chan_array;
@@ -186,7 +186,7 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 		if (stepid == map_val) {
 			read = read & FIFOREAD_DATA_MASK;
 			found = true;
-			*val = read;
+			*val = (u16) read;
 		}
 	}
 
-- 
1.7.9.5

