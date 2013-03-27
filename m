Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3C0JB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:01:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:59701 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755283Ab3C0I63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:58:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,917,1355126400"; 
   d="scan'208";a="219350182"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5/6] ACPI / LPSS: return no error from register_device_clock in special cases
Date: Wed, 27 Mar 2013 10:58:01 +0200
Message-Id: <1364374682-8547-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1364374682-8547-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1364374682-8547-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When device uses the fixed clock and has no private space of LTR, we have to
create main LPSS clock and register platform device. This is normally a case
for LPSS DMA controller.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/acpi/acpi_lpss.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index b1c9542..4015929 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -95,6 +95,10 @@ static int register_device_clock(struct acpi_device *adev,
 	if (!lpss_clk_dev)
 		lpt_register_clock_device();
 
+	if (!dev_desc->prv_offset && dev_desc->clk_required)
+		/* There is no error when device uses fixed clock */
+		return 0;
+
 	if (!dev_desc->clk_parent || !pdata->mmio_base
 	    || pdata->mmio_size < dev_desc->prv_offset + LPSS_CLK_SIZE)
 		return -ENODATA;
-- 
1.8.2.rc0.22.gb3600c3

