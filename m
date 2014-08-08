Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbaHHVci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:32:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40641 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119AbaHHUsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:48:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 022/259] staging: iio/ad7291: fix error code in ad7291_probe()
Date: Fri,  8 Aug 2014 13:37:25 -0700
Message-Id: <1407530482-4483-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b70e19c222a64018d308ebc80333575aff9f4e51 upstream.

We should be returning a negative error code instead of success here.

This would have been detected by GCC, except that the "ret" variable was
initialized with a bogus value to disable GCC's uninitialized variable
warnings.  I've cleaned that up, as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/iio/adc/ad7291.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/adc/ad7291.c b/drivers/staging/iio/adc/ad7291.c
index d13f8ae..6c88359 100644
--- a/drivers/staging/iio/adc/ad7291.c
+++ b/drivers/staging/iio/adc/ad7291.c
@@ -465,7 +465,7 @@ static int ad7291_probe(struct i2c_client *client,
 	struct ad7291_platform_data *pdata = client->dev.platform_data;
 	struct ad7291_chip_info *chip;
 	struct iio_dev *indio_dev;
-	int ret = 0;
+	int ret;
 
 	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*chip));
 	if (!indio_dev)
@@ -475,7 +475,7 @@ static int ad7291_probe(struct i2c_client *client,
 	if (pdata && pdata->use_external_ref) {
 		chip->reg = devm_regulator_get(&client->dev, "vref");
 		if (IS_ERR(chip->reg))
-			return ret;
+			return PTR_ERR(chip->reg);
 
 		ret = regulator_enable(chip->reg);
 		if (ret)
-- 
1.9.1

