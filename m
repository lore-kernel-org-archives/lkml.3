Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899Ab3IYBNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:13:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3IYAQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Vasut <marex@denx.de>, Otavio Salvador <otavio@ossystems.com.br>,
        Hector Palacios <hector.palacios@digi.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [ 032/110] iio: mxs-lradc: Remove useless check in read_raw
Date: Tue, 24 Sep 2013 17:14:30 -0700
Message-Id: <20130925001326.889339096@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

commit 2a961d0995cdadbfba565b28beada59c5ae7ebae upstream.

The removed check in the read_raw implementation was always true,
therefore remove it. This also fixes a bug, by closely inspecting
the code, one can notice the iio_validate_scan_mask_onehot() will
always return 1 and therefore the subsequent condition will always
succeed, therefore making the mxs_lradc_read_raw() function always
return -EINVAL; .

Signed-off-by: Marek Vasut <marex@denx.de>
Tested-by: Otavio Salvador <otavio@ossystems.com.br>
Acked-by: Hector Palacios <hector.palacios@digi.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/adc/mxs-lradc.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -234,7 +234,6 @@ static int mxs_lradc_read_raw(struct iio
 {
 	struct mxs_lradc *lradc = iio_priv(iio_dev);
 	int ret;
-	unsigned long mask;
 
 	if (m != IIO_CHAN_INFO_RAW)
 		return -EINVAL;
@@ -243,12 +242,6 @@ static int mxs_lradc_read_raw(struct iio
 	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
 		return -EINVAL;
 
-	/* Validate the channel if it doesn't intersect with reserved chans. */
-	bitmap_set(&mask, chan->channel, 1);
-	ret = iio_validate_scan_mask_onehot(iio_dev, &mask);
-	if (ret)
-		return -EINVAL;
-
 	/*
 	 * See if there is no buffered operation in progess. If there is, simply
 	 * bail out. This can be improved to support both buffered and raw IO at


