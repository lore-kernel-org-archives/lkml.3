Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaKQNR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:17:26 -0500
Received: from mga03.intel.com ([134.134.136.65]:18423 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbaKQNRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:17:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,402,1413270000"; 
   d="scan'208";a="609081146"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kmx61: Use uscale instead of scale
Date: Mon, 17 Nov 2014 15:18:35 +0200
Message-Id: <1416230316-14511-2-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416230316-14511-1-git-send-email-daniel.baluta@intel.com>
References: <1416230316-14511-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it easier to notice that we only use
the micro part for scale.

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/imu/kmx61.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
index 2bd77dd..e49b1cc 100644
--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -90,7 +90,7 @@ enum kmx61_scan {
 };
 
 static const struct {
-	u16 scale;
+	u16 uscale;
 	u8 gsel0;
 	u8 gsel1;
 } kmx61_scale_table[] = {
@@ -337,13 +337,13 @@ static int kmx61_set_range(struct kmx61_data *data, int range)
 	return 0;
 }
 
-static int kmx61_set_scale(struct kmx61_data *data, int val)
+static int kmx61_set_scale(struct kmx61_data *data, int uscale)
 {
 	int ret, i;
 	u8  mode;
 
 	for (i = 0; i < ARRAY_SIZE(kmx61_scale_table); i++) {
-		if (kmx61_scale_table[i].scale == val) {
+		if (kmx61_scale_table[i].uscale == uscale) {
 			ret = kmx61_get_mode(data, &mode,
 					     KMX61_ACC | KMX61_MAG);
 			if (ret < 0)
@@ -441,7 +441,7 @@ static int kmx61_read_raw(struct iio_dev *indio_dev,
 		switch (chan->type) {
 		case IIO_ACCEL:
 			*val = 0;
-			*val2 = kmx61_scale_table[data->range].scale;
+			*val2 = kmx61_scale_table[data->range].uscale;
 			return IIO_VAL_INT_PLUS_MICRO;
 		case IIO_MAGN:
 			/* 14 bits res, 1465 microGauss per magn count */
-- 
1.9.1

