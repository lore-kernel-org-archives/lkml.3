Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaH0IiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 04:38:20 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:40029 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752644AbaH0IiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 04:38:17 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2014 04:38:17 EDT
From: Josh Wu <josh.wu@atmel.com>
To: <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <jic23@kernel.org>
CC: <alexandre.belloni@free-electrons.com>, <maxime.ripard@free-electrons.com>,
        <nicolas.ferre@atmel.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH] iio: adc: at91: make the function handle_adc_eoc_trigger() static
Date: Wed, 27 Aug 2014 16:31:11 +0800
Message-ID: <1409128271-14856-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The handle_adc_eoc_trigger() in only used in at91_adc.c. So make it
static.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/iio/adc/at91_adc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index 772e869..7807e0e 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -266,7 +266,7 @@ static irqreturn_t at91_adc_trigger_handler(int irq, void *p)
 }
 
 /* Handler for classic adc channel eoc trigger */
-void handle_adc_eoc_trigger(int irq, struct iio_dev *idev)
+static void handle_adc_eoc_trigger(int irq, struct iio_dev *idev)
 {
 	struct at91_adc_state *st = iio_priv(idev);
 
-- 
1.9.1

