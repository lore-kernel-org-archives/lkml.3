Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbaGHAzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:55:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbaGGXyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.15 098/122] staging: iio/ad7291: fix error code in ad7291_probe()
Date: Mon,  7 Jul 2014 16:57:40 -0700
Message-Id: <20140707235737.192375171@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b70e19c222a64018d308ebc80333575aff9f4e51 upstream.

We should be returning a negative error code instead of success here.

This would have been detected by GCC, except that the "ret" variable was
initialized with a bogus value to disable GCC's uninitialized variable
warnings.  I've cleaned that up, as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/iio/adc/ad7291.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/iio/adc/ad7291.c
+++ b/drivers/staging/iio/adc/ad7291.c
@@ -465,7 +465,7 @@ static int ad7291_probe(struct i2c_clien
 	struct ad7291_platform_data *pdata = client->dev.platform_data;
 	struct ad7291_chip_info *chip;
 	struct iio_dev *indio_dev;
-	int ret = 0;
+	int ret;
 
 	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*chip));
 	if (!indio_dev)
@@ -475,7 +475,7 @@ static int ad7291_probe(struct i2c_clien
 	if (pdata && pdata->use_external_ref) {
 		chip->reg = devm_regulator_get(&client->dev, "vref");
 		if (IS_ERR(chip->reg))
-			return ret;
+			return PTR_ERR(chip->reg);
 
 		ret = regulator_enable(chip->reg);
 		if (ret)


