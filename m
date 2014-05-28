Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaE1KWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:22:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36128 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbaE1KWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:22:01 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH 7/9] regulator: palmas: Add palmas_pmic_driver_data structure
Date: Wed, 28 May 2014 15:50:20 +0530
Message-ID: <1401272423-25761-8-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
References: <1401272423-25761-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add palmas_pmic_driver_data structure.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 include/linux/mfd/palmas.h |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 8d68452..70f0695 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -53,6 +53,8 @@ struct palmas_pmic;
 struct palmas_gpadc;
 struct palmas_resource;
 struct palmas_usb;
+struct palmas_pmic_driver_data;
+struct palmas_pmic_platform_data;
 
 enum palmas_usb_state {
 	PALMAS_USB_STATE_DISCONNECT,
@@ -76,6 +78,8 @@ struct palmas {
 	struct mutex irq_lock;
 	struct regmap_irq_chip_data *irq_data;
 
+	struct palmas_pmic_driver_data *pmic_ddata;
+
 	/* Child Devices */
 	struct palmas_pmic *pmic;
 	struct palmas_gpadc *gpadc;
@@ -107,6 +111,27 @@ struct regs_info {
 	int	sleep_id;
 };
 
+struct palmas_pmic_driver_data {
+	int smps_start;
+	int smps_end;
+	int ldo_begin;
+	int ldo_end;
+	int max_reg;
+	struct regs_info *palmas_regs_info;
+	struct of_regulator_match *palmas_matches;
+	struct palmas_sleep_requestor_info *sleep_req_info;
+	int (*smps_register)(struct palmas_pmic *pmic,
+			     struct palmas_pmic_driver_data *ddata,
+			     struct palmas_pmic_platform_data *pdata,
+			     const char *pdev_name,
+			     struct regulator_config config);
+	int (*ldo_register)(struct palmas_pmic *pmic,
+			    struct palmas_pmic_driver_data *ddata,
+			    struct palmas_pmic_platform_data *pdata,
+			    const char *pdev_name,
+			    struct regulator_config config);
+};
+
 struct palmas_gpadc_platform_data {
 	/* Channel 3 current source is only enabled during conversion */
 	int ch3_current;
-- 
1.7.9.5

