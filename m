Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965168AbaGCJek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:34:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52513 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030480AbaGCJYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 167/198] staging: iio: tsl2x7x_core: fix proximity treshold
Date: Thu,  3 Jul 2014 10:20:10 +0100
Message-Id: <1404379241-8590-168-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>

commit c404618cd06dad771495fe1cf9d5a63b5664f65f upstream.

Consider high byte of proximity min and max treshold in function
'tsl2x7x_chip_on'. So far, the high byte was not set.

Signed-off-by: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/iio/light/tsl2x7x_core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2x7x_core.c b/drivers/staging/iio/light/tsl2x7x_core.c
index c99f890cc6c6..64c73adfa3b0 100644
--- a/drivers/staging/iio/light/tsl2x7x_core.c
+++ b/drivers/staging/iio/light/tsl2x7x_core.c
@@ -672,9 +672,13 @@ static int tsl2x7x_chip_on(struct iio_dev *indio_dev)
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

