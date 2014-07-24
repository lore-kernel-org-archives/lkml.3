Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829AbaGXJtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:49:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55167 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934799AbaGXJtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:49:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kardell <jan.kardell@telliq.com>, Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 112/128] iio: ti_am335x_adc: Fix: Use same step id at FIFOs both ends
Date: Thu, 24 Jul 2014 10:46:01 +0100
Message-Id: <1406195177-8656-113-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kardell <jan.kardell@telliq.com>

commit baa3c65298c089a9014b4e523a14ec2885cca1bc upstream.

Since AI lines could be selected at will (linux-3.11) the sending
and receiving ends of the FIFO does not agree about what step is used
for a line. It only works if the last lines are used, like 5,6,7,
and fails if ie 2,4,6 is selected in DT.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
Tested-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/adc/ti_am335x_adc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 3ceac3e91dde..9dd72d05abc3 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -155,7 +155,7 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 		if (time_after(jiffies, timeout))
 			return -EAGAIN;
 		}
-	map_val = chan->channel + TOTAL_CHANNELS;
+	map_val = adc_dev->channel_step[chan->scan_index];
 
 	/*
 	 * When the sub-system is first enabled,
-- 
1.9.1

