Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaKLNj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:39:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:43860 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbaKLNiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:38:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,369,1413270000"; 
   d="scan'208";a="635695097"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Johan Havold <johan@kernel.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@intel.com>
Subject: [PATCH v2 2/2] mfd: dln2: add support for USB-SPI module
Date: Wed, 12 Nov 2014 15:38:10 +0200
Message-Id: <1415799490-27989-3-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415799490-27989-1-git-send-email-laurentiu.palcu@intel.com>
References: <1415799490-27989-1-git-send-email-laurentiu.palcu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
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

