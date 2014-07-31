Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaGaNiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:38:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:64241 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaGaNiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:38:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,772,1400050800"; 
   d="scan'208";a="551824378"
From: Jie Yang <yang.jie@intel.com>
To: linux-acpi@vger.kernel.org
Cc: rjw@rjwysocki.net, lenb@kernel.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, liam.r.girdwood@intel.com,
        vinod.koul@intel.com, yang.jie@intel.com, mengdong.lin@intel.com
Subject: [PATCH] ACPI / LPSS: add lpss device for wpt
Date: Thu, 31 Jul 2014 21:39:08 +0800
Message-Id: <1406813948-10417-1-git-send-email-yang.jie@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lpss device "INT3438" for wpt, which also require
clock before the dma engine who is built in ADSP
probing. Otherwise, the probing may faild.

Signed-off-by: Jie Yang <yang.jie@intel.com>
---
 drivers/acpi/acpi_lpss.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 9cb65b0..ce06149 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -113,6 +113,14 @@ static void lpss_i2c_setup(struct lpss_private_data *pdata)
 	writel(val, pdata->mmio_base + offset);
 }
 
+static struct lpss_device_desc wpt_dev_desc = {
+	.clk_required = true,
+	.prv_offset = 0x800,
+	.ltr_required = true,
+	.clk_divider = true,
+	.clk_gate = true,
+};
+
 static struct lpss_device_desc lpt_dev_desc = {
 	.clk_required = true,
 	.prv_offset = 0x800,
@@ -226,6 +234,8 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
 	{ "INT3436", LPSS_ADDR(lpt_sdio_dev_desc) },
 	{ "INT3437", },
 
+	{ "INT3438", LPSS_ADDR(wpt_dev_desc) },
+
 	{ }
 };
 
-- 
1.8.3.2

