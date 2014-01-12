Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaALTzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 14:55:04 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:62196 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaALTzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 14:55:01 -0500
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: jic23@kernel.org
Cc: pali.rohar@gmail.com, pavel@ucw.cz, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCH] iio: tsl2563: Initialize channels
Date: Sun, 12 Jan 2014 21:54:24 +0200
Message-Id: <1389556464-692-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivaylo Dimitrov <freemangordon@abv.bg>

Correctly initialize device channels, otherwise writing the calibration
values to sysfs nodes does not work

Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
---
 drivers/iio/light/tsl2563.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/tsl2563.c b/drivers/iio/light/tsl2563.c
index 5e5d9de..a663ea2 100644
--- a/drivers/iio/light/tsl2563.c
+++ b/drivers/iio/light/tsl2563.c
@@ -460,7 +460,7 @@ static int tsl2563_write_raw(struct iio_dev *indio_dev,
 {
 	struct tsl2563_chip *chip = iio_priv(indio_dev);
 
-	if (chan->channel == IIO_MOD_LIGHT_BOTH)
+	if (chan->channel == 0)
 		chip->calib0 = calib_from_sysfs(val);
 	else
 		chip->calib1 = calib_from_sysfs(val);
@@ -543,11 +543,12 @@ static const struct iio_event_spec tsl2563_events[] = {
 static const struct iio_chan_spec tsl2563_channels[] = {
 	{
 		.type = IIO_LIGHT,
+		.channel = 0,
 		.indexed = 1,
 		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
-		.channel = 0,
 	}, {
 		.type = IIO_INTENSITY,
+		.channel = 0,
 		.modified = 1,
 		.channel2 = IIO_MOD_LIGHT_BOTH,
 		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
@@ -556,6 +557,7 @@ static const struct iio_chan_spec tsl2563_channels[] = {
 		.num_event_specs = ARRAY_SIZE(tsl2563_events),
 	}, {
 		.type = IIO_INTENSITY,
+		.channel = 1,
 		.modified = 1,
 		.channel2 = IIO_MOD_LIGHT_IR,
 		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
-- 
1.5.6.1

