Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbaAMQxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:53:05 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34355 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753201AbaAMQCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:12 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Marek Vasut <marex@denx.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/3] iio: mxs-lradc: fix invalid channel number detection
Date: Mon, 13 Jan 2014 17:02:02 +0100
Message-Id: <1389628923-8689-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628923-8689-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1389628923-8689-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16 would be accepted as a channel number but it is invalid. It doesn't really
have any effect as mxs_lradc_read_raw is called from a "controlled" environment
so it it only gets values going from 0 to 15.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/staging/iio/adc/mxs-lradc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index aa86849daeba..2289dc1bd928 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -898,7 +898,7 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
 	struct mxs_lradc *lradc = iio_priv(iio_dev);
 
 	/* Check for invalid channel */
-	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
+	if (chan->channel >= LRADC_MAX_TOTAL_CHANS)
 		return -EINVAL;
 
 	switch (m) {
-- 
1.8.3.2

