Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbaFXQBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:01:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965156AbaFXP4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mario Schuknecht <mario.schuknecht@dresearch-fe.de>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.15 42/61] staging: iio: tsl2x7x_core: fix proximity treshold
Date: Tue, 24 Jun 2014 11:51:25 -0400
Message-Id: <20140624154954.700802359@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>

commit c404618cd06dad771495fe1cf9d5a63b5664f65f upstream.

Consider high byte of proximity min and max treshold in function
'tsl2x7x_chip_on'. So far, the high byte was not set.

Signed-off-by: Mario Schuknecht <mario.schuknecht@dresearch-fe.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/light/tsl2x7x_core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/staging/iio/light/tsl2x7x_core.c
+++ b/drivers/staging/iio/light/tsl2x7x_core.c
@@ -667,9 +667,13 @@ static int tsl2x7x_chip_on(struct iio_de
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


