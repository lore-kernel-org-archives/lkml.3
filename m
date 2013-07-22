Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab3GVLQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:16:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39126 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab3GVLQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:16:11 -0400
From: Oleksandr Kravchenko <x0199363@ti.com>
To: <jic23@cam.ac.uk>
CC: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
Subject: [PATCH] iio: core: Avoid double minus in sysfs output
Date: Mon, 22 Jul 2013 14:16:03 +0300
Message-ID: <1374491763-16149-1-git-send-email-x0199363@ti.com>
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
 drivers/iio/industrialio-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index d56d122..97f0297 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -383,14 +383,14 @@ static ssize_t iio_read_channel_info(struct device *dev,
 		scale_db = true;
 	case IIO_VAL_INT_PLUS_MICRO:
 		if (val2 < 0)
-			return sprintf(buf, "-%d.%06u%s\n", val, -val2,
+			return sprintf(buf, "-%ld.%06u%s\n", abs(val), -val2,
 				scale_db ? " dB" : "");
 		else
 			return sprintf(buf, "%d.%06u%s\n", val, val2,
 				scale_db ? " dB" : "");
 	case IIO_VAL_INT_PLUS_NANO:
 		if (val2 < 0)
-			return sprintf(buf, "-%d.%09u\n", val, -val2);
+			return sprintf(buf, "-%ld.%09u\n", abs(val), -val2);
 		else
 			return sprintf(buf, "%d.%09u\n", val, val2);
 	case IIO_VAL_FRACTIONAL:
-- 
1.7.9.5

