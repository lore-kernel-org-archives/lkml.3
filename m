Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3IJMwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:52:30 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51505 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3IJMuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:50:20 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 32/38] iio: accel-core: st: Move LSM303DLH into correct group
Date: Tue, 10 Sep 2013 13:49:33 +0100
Message-Id: <1378817379-8238-33-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LSM303DLH's WAI (WhoAmI) is 0x33, meaning it should be enabled by
Accel Sensor group one. For the device to probe without error, we'll
need to ensure it's registered with the correct WAI.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/iio/accel/st_accel_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/st_accel_core.c b/drivers/iio/accel/st_accel_core.c
index ea62291..03a2b6b 100644
--- a/drivers/iio/accel/st_accel_core.c
+++ b/drivers/iio/accel/st_accel_core.c
@@ -170,6 +170,7 @@ static const struct st_sensors st_accel_sensors[] = {
 			[2] = LSM330D_ACCEL_DEV_NAME,
 			[3] = LSM330DL_ACCEL_DEV_NAME,
 			[4] = LSM330DLC_ACCEL_DEV_NAME,
+			[5] = LSM303DLH_ACCEL_DEV_NAME,
 		},
 		.ch = (struct iio_chan_spec *)st_accel_12bit_channels,
 		.odr = {
@@ -238,8 +239,7 @@ static const struct st_sensors st_accel_sensors[] = {
 		.sensors_supported = {
 			[0] = LIS331DLH_ACCEL_DEV_NAME,
 			[1] = LSM303DL_ACCEL_DEV_NAME,
-			[2] = LSM303DLH_ACCEL_DEV_NAME,
-			[3] = LSM303DLM_ACCEL_DEV_NAME,
+			[2] = LSM303DLM_ACCEL_DEV_NAME,
 		},
 		.ch = (struct iio_chan_spec *)st_accel_12bit_channels,
 		.odr = {
-- 
1.8.1.2

