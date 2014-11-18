Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaKRMKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:10:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:58094 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbaKRMKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:10:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,409,1413270000"; 
   d="scan'208";a="638919933"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Johan Havold <johan@kernel.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@intel.com>
Subject: [PATCH v3 2/2] mfd: dln2: add support for USB-SPI module
Date: Tue, 18 Nov 2014 14:09:59 +0200
Message-Id: <1416312599-5176-3-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416312599-5176-1-git-send-email-laurentiu.palcu@intel.com>
References: <1416312599-5176-1-git-send-email-laurentiu.palcu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
---
 drivers/mfd/dln2.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index 9765a17..0cdad2d 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -52,6 +52,7 @@ enum dln2_handle {
 	DLN2_HANDLE_CTRL,
 	DLN2_HANDLE_GPIO,
 	DLN2_HANDLE_I2C,
+	DLN2_HANDLE_SPI,
 	DLN2_HANDLES
 };
 
@@ -634,6 +635,12 @@ static struct dln2_platform_data dln2_pdata_i2c = {
 	.port = 0,
 };
 
+/* Only one SPI port supported */
+static struct dln2_platform_data dln2_pdata_spi = {
+	.handle = DLN2_HANDLE_SPI,
+	.port = 0,
+};
+
 static const struct mfd_cell dln2_devs[] = {
 	{
 		.name = "dln2-gpio",
@@ -645,6 +652,11 @@ static const struct mfd_cell dln2_devs[] = {
 		.platform_data = &dln2_pdata_i2c,
 		.pdata_size = sizeof(struct dln2_platform_data),
 	},
+	{
+		.name = "dln2-spi",
+		.platform_data = &dln2_pdata_spi,
+		.pdata_size = sizeof(struct dln2_platform_data),
+	},
 };
 
 static void dln2_disconnect(struct usb_interface *interface)
-- 
1.9.1

