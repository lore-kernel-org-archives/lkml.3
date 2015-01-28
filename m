Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723AbbA1EwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:52:03 -0500
Received: from mail.kernel.org ([198.145.29.136]:39816 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761653AbbA1EWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:22:10 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 088/177] staging:iio:impedance-analyzer:ad5933 unwind use of IIO_CHAN macro.
Date: Wed, 28 Jan 2015 12:09:03 +0800
Message-Id: <1422418236-12852-176-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@kernel.org>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit cdacc05bfa479997424fa9a3b54c07573b0ce4ed upstream.

This macro is being removed to simplify ongoing maintenance
so we need to unwind and remaining users.

Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/staging/iio/impedance-analyzer/ad5933.c | 47 ++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/iio/impedance-analyzer/ad5933.c b/drivers/staging/iio/impedance-analyzer/ad5933.c
index cd82b56..06b9fe2 100644
--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -109,15 +109,44 @@ static struct ad5933_platform_data ad5933_default_pdata  = {
 };
 
 static struct iio_chan_spec ad5933_channels[] = {
-	IIO_CHAN(IIO_TEMP, 0, 1, 1, NULL, 0, 0, 0,
-		 0, AD5933_REG_TEMP_DATA, IIO_ST('s', 14, 16, 0), 0),
-	/* Ring Channels */
-	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "real_raw", 0, 0,
-		 IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
-		 AD5933_REG_REAL_DATA, 0, IIO_ST('s', 16, 16, 0), 0),
-	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "imag_raw", 0, 0,
-		 IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
-		 AD5933_REG_IMAG_DATA, 1, IIO_ST('s', 16, 16, 0), 0),
+	{
+		.type = IIO_TEMP,
+		.indexed = 1,
+		.processed_val = 1,
+		.channel = 0,
+		.address = AD5933_REG_TEMP_DATA,
+		.scan_type = {
+			.sign = 's',
+			.realbits = 14,
+			.storagebits = 16,
+		},
+	}, { /* Ring Channels */
+		.type = IIO_VOLTAGE,
+		.indexed = 1,
+		.channel = 0,
+		.extend_name = "real_raw",
+		.info_mask = IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = AD5933_REG_REAL_DATA,
+		.scan_index = 0,
+		.scan_type = {
+			.sign = 's',
+			.realbits = 16,
+			.storagebits = 16,
+		},
+	}, {
+		.type = IIO_VOLTAGE,
+		.indexed = 1,
+		.channel = 0,
+		.extend_name = "imag_raw",
+		.info_mask = IIO_CHAN_INFO_SCALE_SEPARATE_BIT,
+		.address = AD5933_REG_IMAG_DATA,
+		.scan_index = 1,
+		.scan_type = {
+			.sign = 's',
+			.realbits = 16,
+			.storagebits = 16,
+		},
+	},
 };
 
 static int ad5933_i2c_write(struct i2c_client *client,
-- 
1.9.1

