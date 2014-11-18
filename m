Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbaKROm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:42:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbaKROKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 142/206] staging:iio:ade7758: Remove "raw" from channel name
Date: Tue, 18 Nov 2014 15:08:17 +0100
Message-Id: <9f9387ff8a126a65cd98b169b3acc1aa7f74b602.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b598aacc29331e7e638cd509108600e916c6331b upstream.

"raw" is a property of a channel, but should not be part of the name of
channel.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/iio/meter/ade7758_core.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/iio/meter/ade7758_core.c b/drivers/staging/iio/meter/ade7758_core.c
index 6caeb97e75c8..6f0886f764c7 100644
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
2.1.3

