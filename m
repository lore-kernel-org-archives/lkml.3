Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3CAAMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:12:55 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36810 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3CAAMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:12:54 -0500
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Nishanth Menon <nm@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: core: update kernel documentation for regulator_desc
Date: Thu, 28 Feb 2013 18:12:47 -0600
Message-ID: <1362096767-8157-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit df367931 (regulator: core: Provide regmap get/set bypass
operations) introduced regulator_[gs]et_bypass_regmap

However structure documentation for regulator_desc needs an update.
./scripts/kernel-doc include/linux/regulator/driver.h >/dev/null
generates:
Warning(include/linux/regulator/driver.h:233): No description found for parameter 'bypass_reg'
Warning(include/linux/regulator/driver.h:233): No description found for parameter 'bypass_mask'

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Nishanth Menon <nm@ti.com>

---
the above error is based off:
master de1a226 Merge tag 'writeback-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux
from: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

defconfig used: omap2plus_defconfig

 include/linux/regulator/driver.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 23070fd..7df93f5 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -199,6 +199,8 @@ enum regulator_type {
  *                output when using regulator_set_voltage_sel_regmap
  * @enable_reg: Register for control when using regmap enable/disable ops
  * @enable_mask: Mask for control when using regmap enable/disable ops
+ * @bypass_reg: Register for control when using regmap set_bypass
+ * @bypass_mask: Mask for control when using regmap set_bypass
  *
  * @enable_time: Time taken for initial enable of regulator (in uS).
  */
-- 
1.7.9.5

