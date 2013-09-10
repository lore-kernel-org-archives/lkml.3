Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab3IJVCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:02:34 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:32866 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3IJVCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:02:32 -0400
X-Originating-IP: 83.160.107.163
Date: Tue, 10 Sep 2013 23:02:28 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: Jonathan Cameron <jic23@cam.ac.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Patil, Rachna" <rachna@ti.com>, Felipe Balbi <balbi@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] iio: ti_am335x_adc: Take touchscreen channels into
 account for conversion timeout
Message-ID: <20130910210228.GC30481@raspi>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	Jonathan Cameron <jic23@cam.ac.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Patil, Rachna" <rachna@ti.com>, Felipe Balbi <balbi@ti.com>,
	Pantelis Antoniou <panto@antoniou-consulting.com>,
	linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f1830a7d0debce351966d2f3232158313d87dcc0.1378846446.git.matthias@kaehlcke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1830a7d0debce351966d2f3232158313d87dcc0.1378846446.git.matthias@kaehlcke.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The calculation of the old conversion timeout value was based on the number of
channels used by this driver. This doesn't take into account that other channels
can be used by the touchscreen driver. Adjust the timeout value to the maximum
if the touchscreen driver is enabled

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
---
 drivers/iio/adc/ti_am335x_adc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 3ceac3e..898fc78 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -146,7 +146,11 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 	bool found = false;
 	u32 step_en;
 	unsigned long timeout = jiffies + usecs_to_jiffies
+#ifdef CONFIG_TOUCHSCREEN_TI_AM335X_TSC
+				(IDLE_TIMEOUT * TOTAL_CHANNELS);
+#else
 				(IDLE_TIMEOUT * adc_dev->channels);
+#endif
 	step_en = get_adc_step_mask(adc_dev);
 	am335x_tsc_se_set(adc_dev->mfd_tscadc, step_en);
 
-- 
1.8.4.rc3

