Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaAMOuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:50:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51374 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaAMO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 46/96] iio:adc:ad7887 Fix channel reported endianness from cpu to big endian
Date: Mon, 13 Jan 2014 14:24:09 +0000
Message-Id: <1389623099-18783-47-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <jic23@kernel.org>

commit e39d99059ad7f75d7ae2d3c59055d3c476cdb0d9 upstream.

Note this also sets the endianness to big endian whereas it would
previously have defaulted to the cpu endian.  Hence technically
this is a bug fix on LE platforms.

Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
[ luis: backported to 3.5:
  - adjusted filename: drivers/iio/adc/ad7887.c ->
    drivers/staging/iio/adc/ad7887_core.c
  - adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/iio/adc/ad7887_core.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/adc/ad7887_core.c b/drivers/staging/iio/adc/ad7887_core.c
index 7186074..2b7fc8b 100644
--- a/drivers/staging/iio/adc/ad7887_core.c
+++ b/drivers/staging/iio/adc/ad7887_core.c
@@ -79,7 +79,13 @@ static const struct ad7887_chip_info ad7887_chip_info_tbl[] = {
 			IIO_CHAN_INFO_SCALE_SHARED_BIT,
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
@@ -89,7 +95,13 @@ static const struct ad7887_chip_info ad7887_chip_info_tbl[] = {
 			IIO_CHAN_INFO_SCALE_SHARED_BIT,
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
-- 
1.8.3.2

