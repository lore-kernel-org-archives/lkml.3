Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaCDQur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:50:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39431 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaCDQuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:50:46 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH] mfd: as3722: make FUSE7_REG readable
Date: Tue,  4 Mar 2014 09:50:32 -0700
Message-Id: <1393951832-2638-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The FUSE7_REG register is not currently marked readable. This causes
as3722_sd0_is_low_voltage() to emit an error during boot, and assume
the range of the SD0 regulator:

as3722-regulator as3722-regulator: Reg 0xa7 read failed: -5

Fixes: d4807ad2c4c0 ("regmap: Check readable regs in _regmap_read")
[exposed the bug, by checking for readability]
Fixes: 762a8ee80897 ("regulator: as3722: detect SD0 low-voltage mode")
[left out this register from the readable list]
Cc: Mark Brown <broonie@linaro.org>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: Andrew Bresticker <abrestic@chromium.org>
Cc: Vince Hsu <vinceh@nvidia.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Note: I believe the regmap commit mentioned above is for 3.15, whereas
the as3722 commit is in at least 3.14. So, this only needs to be applied
for 3.15, but might make sense to go into earlier kernels, at your
discretion.
---
 drivers/mfd/as3722.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/as3722.c b/drivers/mfd/as3722.c
index c71ff0af1547..39fa554f13bb 100644
--- a/drivers/mfd/as3722.c
+++ b/drivers/mfd/as3722.c
@@ -277,6 +277,7 @@ static const struct regmap_range as3722_readable_ranges[] = {
 	regmap_reg_range(AS3722_ADC0_CONTROL_REG, AS3722_ADC_CONFIGURATION_REG),
 	regmap_reg_range(AS3722_ASIC_ID1_REG, AS3722_ASIC_ID2_REG),
 	regmap_reg_range(AS3722_LOCK_REG, AS3722_LOCK_REG),
+	regmap_reg_range(AS3722_FUSE7_REG, AS3722_FUSE7_REG),
 };
 
 static const struct regmap_access_table as3722_readable_table = {
-- 
1.8.1.5

