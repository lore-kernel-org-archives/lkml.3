Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaIBKzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:55:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:15035 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbaIBKzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:55:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,448,1406617200"; 
   d="scan'208";a="593287941"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org, Beomho Seo <beomho.seo@samsung.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH] iio: magn: ak8975: fix unnecessary casting between char* and const char*
Date: Tue,  2 Sep 2014 14:04:25 +0300
Message-Id: <1409655865-28912-1-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use const char* instead of casting const char* to char*.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/iio/magnetometer/ak8975.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index a235792..61edc66 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -477,7 +477,7 @@ static const struct acpi_device_id ak_acpi_match[] = {
 };
 MODULE_DEVICE_TABLE(acpi, ak_acpi_match);
 
-static char *ak8975_match_acpi_device(struct device *dev,
+static const char *ak8975_match_acpi_device(struct device *dev,
 				enum asahi_compass_chipset *chipset)
 {
 	const struct acpi_device_id *id;
@@ -487,7 +487,7 @@ static char *ak8975_match_acpi_device(struct device *dev,
 		return NULL;
 	*chipset = (int)id->driver_data;
 
-	return (char *)dev_name(dev);
+	return dev_name(dev);
 }
 
 static int ak8975_probe(struct i2c_client *client,
@@ -497,7 +497,7 @@ static int ak8975_probe(struct i2c_client *client,
 	struct iio_dev *indio_dev;
 	int eoc_gpio;
 	int err;
-	char *name = NULL;
+	const char *name = NULL;
 
 	/* Grab and set up the supplied GPIO. */
 	if (client->dev.platform_data)
@@ -539,7 +539,7 @@ static int ak8975_probe(struct i2c_client *client,
 	if (id) {
 		data->chipset =
 			(enum asahi_compass_chipset)(id->driver_data);
-		name = (char *) id->name;
+		name = id->name;
 	} else if (ACPI_HANDLE(&client->dev))
 		name = ak8975_match_acpi_device(&client->dev, &data->chipset);
 	else
-- 
1.7.9.5

