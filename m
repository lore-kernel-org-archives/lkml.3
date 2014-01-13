Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaAMQuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:50:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53115 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaAMQC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 067/208] iio:imu:adis16400 fix pressure channel scan type
Date: Mon, 13 Jan 2014 15:58:28 +0000
Message-Id: <1389628849-1614-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/imu/adis16400_core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis16400_core.c b/drivers/iio/imu/adis16400_core.c
index f60591f..e58c529 100644
--- a/drivers/iio/imu/adis16400_core.c
+++ b/drivers/iio/imu/adis16400_core.c
@@ -651,7 +651,12 @@ static const struct iio_chan_spec adis16448_channels[] = {
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
-- 
1.8.3.2

