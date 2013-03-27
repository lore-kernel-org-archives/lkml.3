Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3C0I6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:58:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:47262 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab3C0I6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:58:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,917,1355126400"; 
   d="scan'208";a="285153145"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6/6] ACPI / LPSS: add Lynxpoint DMA controller to the list
Date: Wed, 27 Mar 2013 10:58:02 +0200
Message-Id: <1364374682-8547-7-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1364374682-8547-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1364374682-8547-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Lynxpoint we have to enable clock per each LPSS device. That's why we have
to enumerate them from drivers/acpi/acpi_lpss.c. The DMA controller is one of
such devices.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/acpi/acpi_lpss.c  | 7 +++++++
 drivers/clk/x86/clk-lpt.c | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 4015929..d80c81e 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -47,6 +47,10 @@ struct lpss_private_data {
 	const struct lpss_device_desc *dev_desc;
 };
 
+static struct lpss_device_desc lpss_dev_desc = {
+	.clk_required = true,
+};
+
 static struct lpss_device_desc lpt_dev_desc = {
 	.clk_required = true,
 	.clk_parent = "lpss_clk",
@@ -60,6 +64,9 @@ static struct lpss_device_desc lpt_sdio_dev_desc = {
 };
 
 static const struct acpi_device_id acpi_lpss_device_ids[] = {
+	/* Generic LPSS devices */
+	{ "INTL9C60", (unsigned long)&lpss_dev_desc },
+
 	/* Lynxpoint LPSS devices */
 	{ "INT33C0", (unsigned long)&lpt_dev_desc },
 	{ "INT33C1", (unsigned long)&lpt_dev_desc },
diff --git a/drivers/clk/x86/clk-lpt.c b/drivers/clk/x86/clk-lpt.c
index 5cf4f46..719817e 100644
--- a/drivers/clk/x86/clk-lpt.c
+++ b/drivers/clk/x86/clk-lpt.c
@@ -30,7 +30,7 @@ static int lpt_clk_probe(struct platform_device *pdev)
 		return PTR_ERR(clk);
 
 	/* Shared DMA clock */
-	clk_register_clkdev(clk, "hclk", "INTL9C60.0.auto");
+	clk_register_clkdev(clk, "hclk", "INTL9C60:00");
 	return 0;
 }
 
-- 
1.8.2.rc0.22.gb3600c3

