Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966548AbaKLByL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:54:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966493AbaKLByG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:54:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.10 080/123] staging:iio:ade7758: Remove "raw" from channel name
Date: Wed, 12 Nov 2014 10:17:26 +0900
Message-Id: <20141112011722.640397876@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit b598aacc29331e7e638cd509108600e916c6331b upstream.

"raw" is a property of a channel, but should not be part of the name of
channel.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/meter/ade7758_core.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- a/drivers/staging/iio/meter/ade7758_core.c
+++ b/drivers/staging/iio/meter/ade7758_core.c
@@ -648,7 +648,6 @@ static const struct iio_chan_spec ade775
 		.type = IIO_VOLTAGE,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "raw",
 		.address = AD7758_WT(AD7758_PHASE_A, AD7758_VOLTAGE),
 		.scan_index = 0,
 		.scan_type = {
@@ -660,7 +659,6 @@ static const struct iio_chan_spec ade775
 		.type = IIO_CURRENT,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "raw",
 		.address = AD7758_WT(AD7758_PHASE_A, AD7758_CURRENT),
 		.scan_index = 1,
 		.scan_type = {
@@ -672,7 +670,7 @@ static const struct iio_chan_spec ade775
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "apparent_raw",
+		.extend_name = "apparent",
 		.address = AD7758_WT(AD7758_PHASE_A, AD7758_APP_PWR),
 		.scan_index = 2,
 		.scan_type = {
@@ -684,7 +682,7 @@ static const struct iio_chan_spec ade775
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "active_raw",
+		.extend_name = "active",
 		.address = AD7758_WT(AD7758_PHASE_A, AD7758_ACT_PWR),
 		.scan_index = 3,
 		.scan_type = {
@@ -696,7 +694,7 @@ static const struct iio_chan_spec ade775
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 0,
-		.extend_name = "reactive_raw",
+		.extend_name = "reactive",
 		.address = AD7758_WT(AD7758_PHASE_A, AD7758_REACT_PWR),
 		.scan_index = 4,
 		.scan_type = {
@@ -708,7 +706,6 @@ static const struct iio_chan_spec ade775
 		.type = IIO_VOLTAGE,
 		.indexed = 1,
 		.channel = 1,
-		.extend_name = "raw",
 		.address = AD7758_WT(AD7758_PHASE_B, AD7758_VOLTAGE),
 		.scan_index = 5,
 		.scan_type = {
@@ -720,7 +717,6 @@ static const struct iio_chan_spec ade775
 		.type = IIO_CURRENT,
 		.indexed = 1,
 		.channel = 1,
-		.extend_name = "raw",
 		.address = AD7758_WT(AD7758_PHASE_B, AD7758_CURRENT),
 		.scan_index = 6,
 		.scan_type = {
@@ -732,7 +728,7 @@ static const struct iio_chan_spec ade775
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 1,
-		.extend_name = "apparent_raw",
+		.extend_name = "apparent",
 		.address = AD7758_WT(AD7758_PHASE_B, AD7758_APP_PWR),
 		.scan_index = 7,
 		.scan_type = {
@@ -744,7 +740,7 @@ static const struct iio_chan_spec ade775
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 1,
-		.extend_name = "active_raw",
+		.extend_name = "active",
 		.address = AD7758_WT(AD7758_PHASE_B, AD7758_ACT_PWR),
 		.scan_index = 8,
 		.scan_type = {
@@ -756,7 +752,7 @@ static const struct iio_chan_spec ade775
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 1,
-		.extend_name = "reactive_raw",
+		.extend_name = "reactive",
 		.address = AD7758_WT(AD7758_PHASE_B, AD7758_REACT_PWR),
 		.scan_index = 9,
 		.scan_type = {
@@ -768,7 +764,6 @@ static const struct iio_chan_spec ade775
 		.type = IIO_VOLTAGE,
 		.indexed = 1,
 		.channel = 2,
-		.extend_name = "raw",
 		.address = AD7758_WT(AD7758_PHASE_C, AD7758_VOLTAGE),
 		.scan_index = 10,
 		.scan_type = {
@@ -780,7 +775,6 @@ static const struct iio_chan_spec ade775
 		.type = IIO_CURRENT,
 		.indexed = 1,
 		.channel = 2,
-		.extend_name = "raw",
 		.address = AD7758_WT(AD7758_PHASE_C, AD7758_CURRENT),
 		.scan_index = 11,
 		.scan_type = {
@@ -792,7 +786,7 @@ static const struct iio_chan_spec ade775
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 2,
-		.extend_name = "apparent_raw",
+		.extend_name = "apparent",
 		.address = AD7758_WT(AD7758_PHASE_C, AD7758_APP_PWR),
 		.scan_index = 12,
 		.scan_type = {
@@ -804,7 +798,7 @@ static const struct iio_chan_spec ade775
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 2,
-		.extend_name = "active_raw",
+		.extend_name = "active",
 		.address = AD7758_WT(AD7758_PHASE_C, AD7758_ACT_PWR),
 		.scan_index = 13,
 		.scan_type = {
@@ -816,7 +810,7 @@ static const struct iio_chan_spec ade775
 		.type = IIO_POWER,
 		.indexed = 1,
 		.channel = 2,
-		.extend_name = "reactive_raw",
+		.extend_name = "reactive",
 		.address = AD7758_WT(AD7758_PHASE_C, AD7758_REACT_PWR),
 		.scan_index = 14,
 		.scan_type = {


