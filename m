Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaHSMz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:55:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:62841 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaHSMz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:55:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="590180992"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>, Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI / LPSS: Add ACPI IDs for Intel Braswell
Date: Tue, 19 Aug 2014 15:55:22 +0300
Message-Id: <1408452922-15399-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Enable more identifiers for the existing devices for Intel Braswell and
Cherryview.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/acpi_lpss.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index ce06149088c5..9dfec48dd4e5 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -196,6 +196,17 @@ static struct lpss_device_desc byt_i2c_dev_desc = {
 	.setup = lpss_i2c_setup,
 };
 
+static struct lpss_shared_clock bsw_pwm_clock = {
+	.name = "pwm_clk",
+	.rate = 19200000,
+};
+
+static struct lpss_device_desc bsw_pwm_dev_desc = {
+	.clk_required = true,
+	.save_ctx = true,
+	.shared_clock = &bsw_pwm_clock,
+};
+
 #else
 
 #define LPSS_ADDR(desc) (0UL)
@@ -225,6 +236,12 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
 	{ "INT33B2", },
 	{ "INT33FC", },
 
+	/* Braswell LPSS devices */
+	{ "80862288", LPSS_ADDR(bsw_pwm_dev_desc) },
+	{ "8086228A", LPSS_ADDR(byt_uart_dev_desc) },
+	{ "8086228E", LPSS_ADDR(byt_spi_dev_desc) },
+	{ "808622C1", LPSS_ADDR(byt_i2c_dev_desc) },
+
 	{ "INT3430", LPSS_ADDR(lpt_dev_desc) },
 	{ "INT3431", LPSS_ADDR(lpt_dev_desc) },
 	{ "INT3432", LPSS_ADDR(lpt_i2c_dev_desc) },
-- 
2.1.0

