Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbaAFXgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:36:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242AbaAFWkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3.10 014/129] iio:adc:ad7887 Fix channel reported endianness from cpu to big endian
Date: Mon,  6 Jan 2014 14:37:23 -0800
Message-Id: <20140106223859.993835746@linuxfoundation.org>
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

commit e39d99059ad7f75d7ae2d3c59055d3c476cdb0d9 upstream.

Note this also sets the endianness to big endian whereas it would
previously have defaulted to the cpu endian.  Hence technically
this is a bug fix on LE platforms.

Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ad7887.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad7887.c
+++ b/drivers/iio/adc/ad7887.c
@@ -211,7 +211,13 @@ static const struct ad7887_chip_info ad7
 			.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),
 			.address = 1,
 			.scan_index = 1,
-			.scan_type = IIO_ST('u', 12, 16, 0),
+			.scan_type = {
+				.sign = 'u',
+				.realbits = 12,
+				.storagebits = 16,
+				.shift = 0,
+				.endianness = IIO_BE,
+			},
 		},
 		.channel[1] = {
 			.type = IIO_VOLTAGE,
@@ -221,7 +227,13 @@ static const struct ad7887_chip_info ad7
 			.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),
 			.address = 0,
 			.scan_index = 0,
-			.scan_type = IIO_ST('u', 12, 16, 0),
+			.scan_type = {
+				.sign = 'u',
+				.realbits = 12,
+				.storagebits = 16,
+				.shift = 0,
+				.endianness = IIO_BE,
+			},
 		},
 		.channel[2] = IIO_CHAN_SOFT_TIMESTAMP(2),
 		.int_vref_mv = 2500,


