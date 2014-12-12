Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbaLLGhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:37:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51902 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759308AbaLLGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jonathan Cameron" <jic23@kernel.org>,
        "Lars-Peter Clausen" <lars@metafoo.de>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.334780956@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 114/164] staging:iio:ade7758: Remove "raw" from
 channel name
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit b598aacc29331e7e638cd509108600e916c6331b upstream.

"raw" is a property of a channel, but should not be part of the name of
channel.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
[bwh: Backported to 3.2: using IIO_CHAN() macro to initialise the structures]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/iio/meter/ade7758_core.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

--- a/drivers/staging/iio/meter/ade7758_core.c
+++ b/drivers/staging/iio/meter/ade7758_core.c
@@ -662,63 +662,63 @@ static const struct attribute_group ade7
 };
 
 static struct iio_chan_spec ade7758_channels[] = {
-	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "raw", 0, 0,
+	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, NULL, 0, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_A, AD7758_VOLTAGE),
 		0, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_CURRENT, 0, 1, 0, "raw", 0, 0,
+	IIO_CHAN(IIO_CURRENT, 0, 1, 0, NULL, 0, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_A, AD7758_CURRENT),
 		1, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "apparent_raw", 0, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "apparent", 0, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_A, AD7758_APP_PWR),
 		2, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "active_raw", 0, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "active", 0, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_A, AD7758_ACT_PWR),
 		3, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "reactive_raw", 0, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "reactive", 0, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_A, AD7758_REACT_PWR),
 		4, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "raw", 1, 0,
+	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, NULL, 1, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_B, AD7758_VOLTAGE),
 		5, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_CURRENT, 0, 1, 0, "raw", 1, 0,
+	IIO_CHAN(IIO_CURRENT, 0, 1, 0, NULL, 1, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_B, AD7758_CURRENT),
 		6, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "apparent_raw", 1, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "apparent", 1, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_B, AD7758_APP_PWR),
 		7, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "active_raw", 1, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "active", 1, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_B, AD7758_ACT_PWR),
 		8, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "reactive_raw", 1, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "reactive", 1, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_B, AD7758_REACT_PWR),
 		9, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "raw", 2, 0,
+	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, NULL, 2, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_C, AD7758_VOLTAGE),
 		10, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_CURRENT, 0, 1, 0, "raw", 2, 0,
+	IIO_CHAN(IIO_CURRENT, 0, 1, 0, NULL, 2, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_C, AD7758_CURRENT),
 		11, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "apparent_raw", 2, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "apparent", 2, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_C, AD7758_APP_PWR),
 		12, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "active_raw", 2, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "active", 2, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_C, AD7758_ACT_PWR),
 		13, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "reactive_raw", 2, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "reactive", 2, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_C, AD7758_REACT_PWR),
 		14, IIO_ST('s', 24, 32, 0), 0),

