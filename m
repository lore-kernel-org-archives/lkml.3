Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaHABFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:05:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:42373 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbaHABFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:05:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,776,1400050800"; 
   d="scan'208";a="570243845"
From: Jie Yang <yang.jie@intel.com>
To: linux-acpi@vger.kernel.org
Cc: rjw@rjwysocki.net, lenb@kernel.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, liam.r.girdwood@intel.com,
        vinod.koul@intel.com, yang.jie@intel.com, mengdong.lin@intel.com
Subject: [PATCH v2] ACPI / LPSS: add lpss device for Wildcat Point PCH
Date: Fri,  1 Aug 2014 09:06:35 +0800
Message-Id: <1406855195-14275-1-git-send-email-yang.jie@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

INT3438 is the ADSP device on Wildcat Point platform
with 2 DW DMA engines built In. The DMA engines are
used for DSP FW loading and audio data transferring.
These DMA engine probing need the clock, without it,
probing may failed and can't go forward.

Add lpss device "INT3438" for Wildcat Point PCH, to
provide clock for its ADSP DMA engine probing.

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

