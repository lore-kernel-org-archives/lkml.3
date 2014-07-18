Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966054AbaGRNe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:34:26 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17764 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935080AbaGRNOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:14:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kardell <jan.kardell@telliq.com>,
        Jonathan Cameron <jic23@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 131/170] iio: ti_am335x_adc: Fix: Use same step id at FIFOs both ends
Date: Fri, 18 Jul 2014 14:12:16 +0200
Message-Id: <6cbd85608fa0e6b2cd6d14935424e1d988caa130.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kardell <jan.kardell@telliq.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit baa3c65298c089a9014b4e523a14ec2885cca1bc upstream.

Since AI lines could be selected at will (linux-3.11) the sending
and receiving ends of the FIFO does not agree about what step is used
for a line. It only works if the last lines are used, like 5,6,7,
and fails if ie 2,4,6 is selected in DT.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
Tested-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/iio/adc/ti_am335x_adc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index a952538a1a8b..b9ed661293a7 100644
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
2.0.0

