Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814AbaLBT0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:26:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46997 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782AbaLBT0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:48 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 034/121] staging:iio:ade7758: Remove "raw" from channel name
Date: Tue,  2 Dec 2014 11:18:33 -0800
Message-Id: <1417548000-1794-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit b598aacc29331e7e638cd509108600e916c6331b upstream.

"raw" is a property of a channel, but should not be part of the name of
channel.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/iio/meter/ade7758_core.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/iio/meter/ade7758_core.c b/drivers/staging/iio/meter/ade7758_core.c
index 214b03e..94d9914 100644
--- a/drivers/staging/iio/meter/ade7758_core.c
+++ b/drivers/staging/iio/meter/ade7758_core.c
@@ -630,7 +630,6 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_VOLTAGE,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "raw",
 		.address = AD7758_WT(AD7758_PHASE_A, AD7758_VOLTAGE),
 		.scan_index = 0,
 		.scan_type = {
@@ -642,7 +641,6 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_CURRENT,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "raw",
 		.address = AD7758_WT(AD7758_PHASE_A, AD7758_CURRENT),
 		.scan_index = 1,
 		.scan_type = {
@@ -654,7 +652,7 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "apparent_raw",
+		.extend_name = "apparent",
 		.address = AD7758_WT(AD7758_PHASE_A, AD7758_APP_PWR),
 		.scan_index = 2,
 		.scan_type = {
@@ -666,7 +664,7 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "active_raw",
+		.extend_name = "active",
 		.address = AD7758_WT(AD7758_PHASE_A, AD7758_ACT_PWR),
 		.scan_index = 3,
 		.scan_type = {
@@ -678,7 +676,7 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "reactive_raw",
+		.extend_name = "reactive",
 		.address = AD7758_WT(AD7758_PHASE_A, AD7758_REACT_PWR),
 		.scan_index = 4,
 		.scan_type = {
@@ -690,7 +688,6 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_VOLTAGE,
 		.indexed = 1,
 		.channel = 1,
-		.extend_name = "raw",
 		.address = AD7758_WT(AD7758_PHASE_B, AD7758_VOLTAGE),
 		.scan_index = 5,
 		.scan_type = {
@@ -702,7 +699,6 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_CURRENT,
 		.indexed = 1,
 		.channel = 1,
-		.extend_name = "raw",
 		.address = AD7758_WT(AD7758_PHASE_B, AD7758_CURRENT),
 		.scan_index = 6,
 		.scan_type = {
@@ -714,7 +710,7 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 1,
-		.extend_name = "apparent_raw",
+		.extend_name = "apparent",
 		.address = AD7758_WT(AD7758_PHASE_B, AD7758_APP_PWR),
 		.scan_index = 7,
 		.scan_type = {
@@ -726,7 +722,7 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 1,
-		.extend_name = "active_raw",
+		.extend_name = "active",
 		.address = AD7758_WT(AD7758_PHASE_B, AD7758_ACT_PWR),
 		.scan_index = 8,
 		.scan_type = {
@@ -738,7 +734,7 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 1,
-		.extend_name = "reactive_raw",
+		.extend_name = "reactive",
 		.address = AD7758_WT(AD7758_PHASE_B, AD7758_REACT_PWR),
 		.scan_index = 9,
 		.scan_type = {
@@ -750,7 +746,6 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_VOLTAGE,
 		.indexed = 1,
 		.channel = 2,
-		.extend_name = "raw",
 		.address = AD7758_WT(AD7758_PHASE_C, AD7758_VOLTAGE),
 		.scan_index = 10,
 		.scan_type = {
@@ -762,7 +757,6 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_CURRENT,
 		.indexed = 1,
 		.channel = 2,
-		.extend_name = "raw",
 		.address = AD7758_WT(AD7758_PHASE_C, AD7758_CURRENT),
 		.scan_index = 11,
 		.scan_type = {
@@ -774,7 +768,7 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 2,
-		.extend_name = "apparent_raw",
+		.extend_name = "apparent",
 		.address = AD7758_WT(AD7758_PHASE_C, AD7758_APP_PWR),
 		.scan_index = 12,
 		.scan_type = {
@@ -786,7 +780,7 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 2,
-		.extend_name = "active_raw",
+		.extend_name = "active",
 		.address = AD7758_WT(AD7758_PHASE_C, AD7758_ACT_PWR),
 		.scan_index = 13,
 		.scan_type = {
@@ -798,7 +792,7 @@ static const struct iio_chan_spec ade7758_channels[] = {
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 2,
-		.extend_name = "reactive_raw",
+		.extend_name = "reactive",
 		.address = AD7758_WT(AD7758_PHASE_C, AD7758_REACT_PWR),
 		.scan_index = 14,
 		.scan_type = {
-- 
1.9.1

