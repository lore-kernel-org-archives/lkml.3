Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3GVK5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 06:57:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52801 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab3GVK5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 06:57:19 -0400
From: Oleksandr Kravchenko <x0199363@ti.com>
To: <jic23@cam.ac.uk>
CC: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: [PATCH] iio: core: Avoid double minus in sysfs output
Date: Mon, 22 Jul 2013 13:57:11 +0300
Message-ID: <1374490631-11924-1-git-send-email-x0199363@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>

This patch fixes the issue with double minus in output when
reading channels from sysfs for IIO_VAL_INT_PLUS_MICRO and
IIO_VAL_INT_PLUS_NANO cases. Until this patch if val and val2
both are negatives output string contains "--" before
digits. It is result of "-%d..." in sprintf() format.

Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
---
 drivers/iio/industrialio-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index d56d122..455c24b 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -383,14 +383,14 @@ static ssize_t iio_read_channel_info(struct device *dev,
 		scale_db = true;
 	case IIO_VAL_INT_PLUS_MICRO:
 		if (val2 < 0)
-			return sprintf(buf, "-%d.%06u%s\n", val, -val2,
-				scale_db ? " dB" : "");
+			return sprintf(buf, "-%d.%06u%s\n", (int)abs(val),
+				-val2, scale_db ? " dB" : "");
 		else
 			return sprintf(buf, "%d.%06u%s\n", val, val2,
 				scale_db ? " dB" : "");
 	case IIO_VAL_INT_PLUS_NANO:
 		if (val2 < 0)
-			return sprintf(buf, "-%d.%09u\n", val, -val2);
+			return sprintf(buf, "-%d.%09u\n", (int)abs(val), -val2);
 		else
 			return sprintf(buf, "%d.%09u\n", val, val2);
 	case IIO_VAL_FRACTIONAL:
-- 
1.7.9.5

