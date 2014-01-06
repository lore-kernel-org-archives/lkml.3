Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762AbaAFWkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:40:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931AbaAFWkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3.10 013/129] iio:imu:adis16400 fix pressure channel scan type
Date: Mon,  6 Jan 2014 14:37:22 -0800
Message-Id: <20140106223859.966072051@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <jic23@kernel.org>

commit 3425c0f7ac61f2fcfb7f2728e9b7ba7e27aec429 upstream.

A single channel in this driver was using the IIO_ST macro.
This does not provide a parameter for setting the endianness of
the channel.  Thus this channel will have been reported as whatever
is the native endianness of the cpu rather than big endian. This
means it would be incorrect on little endian platforms.

Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/adis16400_core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/adis16400_core.c
+++ b/drivers/iio/imu/adis16400_core.c
@@ -651,7 +651,12 @@ static const struct iio_chan_spec adis16
 		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),
 		.address = ADIS16448_BARO_OUT,
 		.scan_index = ADIS16400_SCAN_BARO,
-		.scan_type = IIO_ST('s', 16, 16, 0),
+		.scan_type = {
+			.sign = 's',
+			.realbits = 16,
+			.storagebits = 16,
+			.endianness = IIO_BE,
+		},
 	},
 	ADIS16400_TEMP_CHAN(ADIS16448_TEMP_OUT, 12),
 	IIO_CHAN_SOFT_TIMESTAMP(11)


