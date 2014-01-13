Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbaAMQtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:49:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53119 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaAMQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 068/208] iio:adc:ad7887 Fix channel reported endianness from cpu to big endian
Date: Mon, 13 Jan 2014 15:58:29 +0000
Message-Id: <1389628849-1614-69-git-send-email-luis.henriques@canonical.com>
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

commit e39d99059ad7f75d7ae2d3c59055d3c476cdb0d9 upstream.

Note this also sets the endianness to big endian whereas it would
previously have defaulted to the cpu endian.  Hence technically
this is a bug fix on LE platforms.

Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/adc/ad7887.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7887.c b/drivers/iio/adc/ad7887.c
index dd15a5b..3394ebd 100644
--- a/drivers/iio/adc/ad7887.c
+++ b/drivers/iio/adc/ad7887.c
@@ -211,7 +211,13 @@ static const struct ad7887_chip_info ad7887_chip_info_tbl[] = {
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
@@ -221,7 +227,13 @@ static const struct ad7887_chip_info ad7887_chip_info_tbl[] = {
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
-- 
1.8.3.2

