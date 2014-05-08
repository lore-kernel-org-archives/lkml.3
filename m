Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbaEHPC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:02:59 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:55021 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbaEHO4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:56:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH] bus/arm-cci: add dependency on OF && CPU_V7
Date: Thu,  8 May 2014 16:56:18 +0200
Message-Id: <1399560990-1402858-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:xpPMIAgy3CAYJJ1lJ8xEA1yeg3SDZb/m62FXZFAV8/C
 l8BRIYjR+ymayeSaLL8QpJCr4kzlsfkSirj4Mp15KhyWMoQy4t
 IxV12cVuzMXzj7YKrvNWL4ty06P83qoHwXy0P2DR31W55I6AQB
 2VB3bpMBdedYE7NlrVQeJpA60fBl+sn0uxH8xhCX1obfGRW6Mw
 pyWjEea6RdD74imoGS1FmvoVMcVN8fUnXywnkn7kFPb+y39t9Y
 U02cmX6sfqpPf+mJH5/dXL+wqo66UbJ77OphxuIP0z6DU1JSR/
 Vkys+4gCKFY3LyL/OX+JSbrl1qU2qGhYvjnWOk6bqPYbv/E8ji
 MxKn4l2LXryjXTRX/V/srjH7Y1fiyGQTPCaN4hMn8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arm-cci code uses device tree helpers for initialization
that don't work on kernels built without CONFIG_OF. Further,
it contains an inline assembly in cci_enable_port_for_self()
that uses ARMv7 instructions and fails to build when targetting
other ARM instruction set versions.

This works around both issues by limiting the scope of the
Kconfig symbol to platforms that can actually build this driver
cleanly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
---
 drivers/bus/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 552373c..d53417e 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -37,7 +37,7 @@ config OMAP_INTERCONNECT
 
 config ARM_CCI
 	bool "ARM CCI driver support"
-	depends on ARM
+	depends on ARM && OF && CPU_V7
 	help
 	  Driver supporting the CCI cache coherent interconnect for ARM
 	  platforms.
-- 
1.8.3.2

