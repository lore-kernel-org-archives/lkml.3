Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaGVWXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:23:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44470 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbaGVWXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:23:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 083/116] staging: iio: tsl2x7x_core: fix proximity treshold
Date: Tue, 22 Jul 2014 15:21:34 -0700
Message-Id: <1406067727-19683-84-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>

commit c404618cd06dad771495fe1cf9d5a63b5664f65f upstream.

Consider high byte of proximity min and max treshold in function
'tsl2x7x_chip_on'. So far, the high byte was not set.

Signed-off-by: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/iio/light/tsl2x7x_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2x7x_core.c b/drivers/staging/iio/light/tsl2x7x_core.c
index 395d8f6..b15b7cb 100644
--- a/drivers/staging/iio/light/tsl2x7x_core.c
+++ b/drivers/staging/iio/light/tsl2x7x_core.c
@@ -725,9 +725,13 @@ static int tsl2x7x_chip_on(struct iio_dev *indio_dev)
 	chip->tsl2x7x_config[TSL2X7X_PRX_COUNT] =
 			chip->tsl2x7x_settings.prox_pulse_count;
 	chip->tsl2x7x_config[TSL2X7X_PRX_MINTHRESHLO] =
-	chip->tsl2x7x_settings.prox_thres_low;
+			(chip->tsl2x7x_settings.prox_thres_low) & 0xFF;
+	chip->tsl2x7x_config[TSL2X7X_PRX_MINTHRESHHI] =
+			(chip->tsl2x7x_settings.prox_thres_low >> 8) & 0xFF;
 	chip->tsl2x7x_config[TSL2X7X_PRX_MAXTHRESHLO] =
-			chip->tsl2x7x_settings.prox_thres_high;
+			(chip->tsl2x7x_settings.prox_thres_high) & 0xFF;
+	chip->tsl2x7x_config[TSL2X7X_PRX_MAXTHRESHHI] =
+			(chip->tsl2x7x_settings.prox_thres_high >> 8) & 0xFF;
 
 	/* and make sure we're not already on */
 	if (chip->tsl2x7x_chip_status == TSL2X7X_CHIP_WORKING) {
-- 
1.9.1

