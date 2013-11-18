Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3KRR0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:26:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab3KRR0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:26:09 -0500
From: Michal Marek <mmarek@suse.cz>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: ldewangan@nvidia.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: Make MFD_AS3722 depend on I2C=y
Date: Mon, 18 Nov 2013 18:25:59 +0100
Message-Id: <1384795559-2116-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MFD_AS3722 can only be builtin, so it needs I2C builtin as well.
With I2C=m, we get:

drivers/mfd/as3722.c:372: undefined reference to `devm_regmap_init_i2c'
drivers/built-in.o: In function `as3722_i2c_driver_init':
drivers/mfd/as3722.c:444: undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `as3722_i2c_driver_exit':
drivers/mfd/as3722.c:444: undefined reference to `i2c_del_driver'

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 62a60ca..dd67158 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -32,7 +32,7 @@ config MFD_AS3722
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
-	depends on I2C && OF
+	depends on I2C=y && OF
 	help
 	  The ams AS3722 is a compact system PMU suitable for mobile phones,
 	  tablets etc. It has 4 DC/DC step-down regulators, 3 DC/DC step-down
-- 
1.7.3.1

