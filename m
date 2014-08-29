Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaH2O1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:27:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:36792 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbaH2O1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:27:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,424,1406617200"; 
   d="scan'208";a="473821908"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Derek Basehore <dbasehore@chromium.org>,
        Teodora Baluta <teodora.baluta@intel.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 1/3] staging: iio: light: isl29018: fix typo
Date: Fri, 29 Aug 2014 17:26:20 +0300
Message-Id: <1409322382-30021-2-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409322382-30021-1-git-send-email-laurentiu.palcu@intel.com>
References: <1409322382-30021-1-git-send-email-laurentiu.palcu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isl29108 was used, instead of isl29018.

Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
---
 drivers/staging/iio/light/isl29018.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
index 86cc8f9..63c70be 100644
--- a/drivers/staging/iio/light/isl29018.c
+++ b/drivers/staging/iio/light/isl29018.c
@@ -447,7 +447,7 @@ static struct attribute *isl29018_attributes[] = {
 	NULL
 };
 
-static const struct attribute_group isl29108_group = {
+static const struct attribute_group isl29018_group = {
 	.attrs = isl29018_attributes,
 };
 
@@ -510,8 +510,8 @@ static int isl29018_chip_init(struct isl29018_chip *chip)
 	return 0;
 }
 
-static const struct iio_info isl29108_info = {
-	.attrs = &isl29108_group,
+static const struct iio_info isl29018_info = {
+	.attrs = &isl29018_group,
 	.driver_module = THIS_MODULE,
 	.read_raw = &isl29018_read_raw,
 	.write_raw = &isl29018_write_raw,
@@ -579,7 +579,7 @@ static int isl29018_probe(struct i2c_client *client,
 	if (err)
 		return err;
 
-	indio_dev->info = &isl29108_info;
+	indio_dev->info = &isl29018_info;
 	indio_dev->channels = isl29018_channels;
 	indio_dev->num_channels = ARRAY_SIZE(isl29018_channels);
 	indio_dev->name = id->name;
-- 
1.9.1

