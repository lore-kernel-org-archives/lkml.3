Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaF1PN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 11:13:26 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:51596 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaF1PNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 11:13:24 -0400
From: Guillaume Morin <guillaume@morinfr.org>
To: gregkh@linuxfoundation.org, jic23@kernel.org
Cc: Guillaume Morin <guillaume@morinfr.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, mwelling@ieee.org
Subject: [PATCH v3 1/1] staging: iio: ad9850.c: code cleanup
Date: Sat, 28 Jun 2014 17:13:19 +0200
Message-Id: <936f1ac494ee8708e37a8cb16a70aa3f007e93cd.1403965958.git.guillaume@morinfr.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpath.pl was complaining about value_mask:
ERROR: Macros with complex values should be enclosed in parenthesis

I fixed this by simply removing it since it's not used (as well as another macro).
Got rid of the un-necessary error_ret label as well.  Both changes were suggested
by Michael Welling.

Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
---
Changes since v2:
- Got rid of the macro altogether since it's unused
- removed unused addr_shit
- remove error_ret since it's not needed

 drivers/staging/iio/frequency/ad9850.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/iio/frequency/ad9850.c b/drivers/staging/iio/frequency/ad9850.c
index af877ff..8727933 100644
--- a/drivers/staging/iio/frequency/ad9850.c
+++ b/drivers/staging/iio/frequency/ad9850.c
@@ -21,9 +21,6 @@
 
 #define DRV_NAME "ad9850"
 
-#define value_mask (u16)0xf000
-#define addr_shift 12
-
 /* Register format: 4 bits addr + 12 bits value */
 struct ad9850_config {
 	u8 control[5];
@@ -50,9 +47,6 @@ static ssize_t ad9850_set_parameter(struct device *dev,
 	mutex_lock(&st->lock);
 
 	ret = spi_sync_transfer(st->sdev, &xfer, 1);
-	if (ret)
-		goto error_ret;
-error_ret:
 	mutex_unlock(&st->lock);
 
 	return ret ? ret : len;
-- 
1.7.10.4

