Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966102AbaFRKCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 06:02:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43286 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965855AbaFRKBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 06:01:05 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH v2 7/9] regulator: palmas: Add palmas_pmic_driver_data structure
Date: Wed, 18 Jun 2014 15:28:58 +0530
Message-ID: <1403085540-20014-8-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403085540-20014-1-git-send-email-j-keerthy@ti.com>
References: <1403085540-20014-1-git-send-email-j-keerthy@ti.com>
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
index 0136e58..1a045ba 100644
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

