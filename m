Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab3KYMXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:23:12 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:37208 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3KYMXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:23:11 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mfd: cros ec: spi: Use consistent function names
Date: Mon, 25 Nov 2013 13:22:30 +0100
Message-Id: <1385382151-28079-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename cros_ec_{probe,remove}_spi() to cros_ec_spi_{probe,remove}() for
consistency.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/mfd/cros_ec_spi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index 27be73523b9c..5658ec48838f 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -284,7 +284,7 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 	return 0;
 }
 
-static int cros_ec_probe_spi(struct spi_device *spi)
+static int cros_ec_spi_probe(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
 	struct cros_ec_device *ec_dev;
@@ -326,7 +326,7 @@ static int cros_ec_probe_spi(struct spi_device *spi)
 	return 0;
 }
 
-static int cros_ec_remove_spi(struct spi_device *spi)
+static int cros_ec_spi_remove(struct spi_device *spi)
 {
 	struct cros_ec_device *ec_dev;
 
@@ -367,8 +367,8 @@ static struct spi_driver cros_ec_driver_spi = {
 		.owner	= THIS_MODULE,
 		.pm	= &cros_ec_spi_pm_ops,
 	},
-	.probe		= cros_ec_probe_spi,
-	.remove		= cros_ec_remove_spi,
+	.probe		= cros_ec_spi_probe,
+	.remove		= cros_ec_spi_remove,
 	.id_table	= cros_ec_spi_id,
 };
 
-- 
1.8.4.2

