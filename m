Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbaGYLOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:14:09 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:64786 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaGYLOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:14:07 -0400
From: Jan Kardell <jan.kardell@telliq.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        Jiri Slaby <jslaby@suse.cz>, Jan Kardell <jan.kardell@telliq.com>
Subject: [PATCH] iio: ti_am335x_adc: Fix prerequisite for stepid patch
Date: Fri, 25 Jul 2014 13:13:46 +0200
Message-Id: <1406286826-30834-1-git-send-email-jan.kardell@telliq.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406195177-8656-113-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-113-git-send-email-luis.henriques@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel series 3.11 and 3.12 does not initialize scan_index in the
iio_chan_spec structure as 3.13 and newer does. This is necessary
for the stepid patch to work, otherwise it even breaks the cases
that worked before the stepid patch.

Unfortunately the stepid patch seems to already be in 3.12.25,
must have missed that inclusion.

Signed-off-by: Jan Kardell <jan.kardell@telliq.com>
---
 drivers/iio/adc/ti_am335x_adc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 3ceac3e..6c56418 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -120,6 +120,7 @@ static int tiadc_channel_init(struct iio_dev *indio_dev, int channels)
 		chan->channel = adc_dev->channel_line[i];
 		chan->info_mask_separate = BIT(IIO_CHAN_INFO_RAW);
 		chan->datasheet_name = chan_name_ain[chan->channel];
+		chan->scan_index = i;
 		chan->scan_type.sign = 'u';
 		chan->scan_type.realbits = 12;
 		chan->scan_type.storagebits = 32;
-- 
1.8.4.5

