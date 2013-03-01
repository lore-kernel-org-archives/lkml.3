Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab3CAApH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:45:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47881 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab3CAApB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:45:01 -0500
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Nishanth Menon <nm@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator: core: fix documentation error in regulator_allow_bypass
Date: Thu, 28 Feb 2013 18:44:54 -0600
Message-ID: <1362098694-8570-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit f59c8f9f (regulator: core: Support bypass mode)
has a short documentation error around the regulator_allow_bypass
parameter 'enable' which is documented as 'allow'.

This generates kernel-doc warning as follows:
./scripts/kernel-doc drivers/regulator/core.c >/dev/null
Warning(drivers/regulator/core.c:2841): No description found for parameter 'enable'
Warning(drivers/regulator/core.c:2841): Excess function parameter 'allow' description in 'regulator_allow_bypass'

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Nishanth Menon <nm@ti.com>
---
the above error is based off:
master de1a226 Merge tag 'writeback-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux
from: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

defconfig used: omap2plus_defconfig

 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index da9782b..154bc8f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2830,7 +2830,7 @@ EXPORT_SYMBOL_GPL(regulator_get_bypass_regmap);
  * regulator_allow_bypass - allow the regulator to go into bypass mode
  *
  * @regulator: Regulator to configure
- * @allow: enable or disable bypass mode
+ * @enable: enable or disable bypass mode
  *
  * Allow the regulator to go into bypass mode if all other consumers
  * for the regulator also enable bypass mode and the machine
-- 
1.7.9.5

