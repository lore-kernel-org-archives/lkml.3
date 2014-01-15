Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaAOWBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:01:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41488 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbaAOWAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:00:55 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonathan Cameron <jic23@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 079/166] iio:adc:ad7887 Fix channel reported endianness from cpu to big endian
Date: Wed, 15 Jan 2014 13:51:33 -0800
Message-Id: <1389822780-4729-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <jic23@kernel.org>

commit e39d99059ad7f75d7ae2d3c59055d3c476cdb0d9 upstream.

Note this also sets the endianness to big endian whereas it would
previously have defaulted to the cpu endian.  Hence technically
this is a bug fix on LE platforms.

Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iio/adc/ad7887.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7887.c b/drivers/iio/adc/ad7887.c
index a33d5cd..b61002b 100644
--- a/drivers/iio/adc/ad7887.c
+++ b/drivers/iio/adc/ad7887.c
@@ -211,7 +211,13 @@ static const struct ad7887_chip_info ad7887_chip_info_tbl[] = {
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
@@ -221,7 +227,13 @@ static const struct ad7887_chip_info ad7887_chip_info_tbl[] = {
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

