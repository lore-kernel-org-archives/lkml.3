Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021AbaLLGsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:48:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbaLLGsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:48:07 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Lars-Peter Clausen" <lars@metafoo.de>,
        "Jonathan Cameron" <jic23@kernel.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.923146748@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 032/164] staging:iio:ad5933: Drop "raw" from channel names
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

commit 6822ee34ad57b29a3b44df2c2829910f03c34fa4 upstream.

"raw" is the name of a channel property, but should not be part of the
channel name itself.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
[bwh: Backported to 3.2: using IIO_CHAN() macro to initialise the structures]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/iio/impedance-analyzer/ad5933.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -112,10 +112,10 @@ static struct iio_chan_spec ad5933_chann
 	IIO_CHAN(IIO_TEMP, 0, 1, 1, NULL, 0, 0, 0,
 		 0, AD5933_REG_TEMP_DATA, IIO_ST('s', 14, 16, 0), 0),
 	/* Ring Channels */
-	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "real_raw", 0, 0,
+	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "real", 0, 0,
 		 (1 << IIO_CHAN_INFO_SCALE_SEPARATE),
 		 AD5933_REG_REAL_DATA, 0, IIO_ST('s', 16, 16, 0), 0),
-	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "imag_raw", 0, 0,
+	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "imag", 0, 0,
 		 (1 << IIO_CHAN_INFO_SCALE_SEPARATE),
 		 AD5933_REG_IMAG_DATA, 1, IIO_ST('s', 16, 16, 0), 0),
 };

