Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbaGORDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:03:05 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:56500 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbaGORCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:15 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jan Kardell <jan.kardell@telliq.com>,
        Jonathan Cameron <jic23@kernel.org>, stable@vger.kernel.org,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 54/94] iio: ti_am335x_adc: Fix: Use same step id at FIFOs both ends
Date: Tue, 15 Jul 2014 20:01:09 +0300
Message-Id: <1405443709-15288-54-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kardell <jan.kardell@telliq.com>

Since AI lines could be selected at will (linux-3.11) the sending
and receiving ends of the FIFO does not agree about what step is used
for a line. It only works if the last lines are used, like 5,6,7,
and fails if ie 2,4,6 is selected in DT.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
Tested-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/iio/adc/ti_am335x_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index a4db302..d5dc4c6 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -374,7 +374,7 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 			return -EAGAIN;
 		}
 	}
-	map_val = chan->channel + TOTAL_CHANNELS;
+	map_val = adc_dev->channel_step[chan->scan_index];
 
 	/*
 	 * We check the complete FIFO. We programmed just one entry but in case
-- 
1.7.10.4

