Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254AbaGOXiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:38:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950AbaGOXOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kardell <jan.kardell@telliq.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.15 05/84] iio: ti_am335x_adc: Fix: Use same step id at FIFOs both ends
Date: Tue, 15 Jul 2014 16:17:02 -0700
Message-Id: <20140715231713.351197257@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ti_am335x_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -374,7 +374,7 @@ static int tiadc_read_raw(struct iio_dev
 			return -EAGAIN;
 		}
 	}
-	map_val = chan->channel + TOTAL_CHANNELS;
+	map_val = adc_dev->channel_step[chan->scan_index];
 
 	/*
 	 * We check the complete FIFO. We programmed just one entry but in case


