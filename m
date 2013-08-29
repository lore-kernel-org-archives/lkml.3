Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab3H2UOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:14:16 -0400
Received: from mail-yh0-f73.google.com ([209.85.213.73]:58670 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3H2UOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:14:14 -0400
From: Derek Basehore <dbasehore@chromium.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>, Bryan Freed <bfreed@chromium.org>,
        Derek Basehore <dbasehore@chromium.org>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iio: isl29018: Fix uninitialized value
Date: Thu, 29 Aug 2013 13:14:10 -0700
Message-Id: <1377807250-30150-1-git-send-email-dbasehore@chromium.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lux_uscale value is not initialized at probe. The value will be
uninitialized unless a value is written to it through the iio channel interface.
This fixes that.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Reviewed-on: https://gerrit.chromium.org/gerrit/65998
---
 drivers/staging/iio/light/isl29018.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
index 82478a5..28c6386 100644
--- a/drivers/staging/iio/light/isl29018.c
+++ b/drivers/staging/iio/light/isl29018.c
@@ -564,6 +564,7 @@ static int isl29018_probe(struct i2c_client *client,
 	mutex_init(&chip->lock);
 
 	chip->lux_scale = 1;
+	chip->lux_uscale = 0;
 	chip->range = 1000;
 	chip->adc_bit = 16;
 	chip->suspended = false;
-- 
1.8.4

