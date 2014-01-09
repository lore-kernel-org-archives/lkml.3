Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbaAIEpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 23:45:33 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50640 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaAIEpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 23:45:30 -0500
From: panchaxari <panchaxari.prasannamurthy@linaro.org>
To: viresh.linux@gmail.com
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        panchaxari.prasannamurthy@linaro.org,
        Will Deacon <will.deacon@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH CFT] ARM:REALVIEW: Enable AUTO_ZRELADDR by default
Date: Thu,  9 Jan 2014 10:14:14 +0530
Message-Id: <1389242654-3925-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables AUTO_ZRELADDR as default config to Realview platform.

AUTO_ZRELADDR config enables auto calculation of the decompressed kernel image
address. AUTO_ZRELADDR config is mutually exclusive to ZBOOT_ROM, and also
assumes zImage to be loaded in the first 128MiB from start of memory.

CFT::Call For Testing

Requesting maintainers of Realview platforms to evaluate the changes on the
board and comment, as I dont have the board for testing, and also requesting
an ACK.

Signed-off-by: panchaxari <panchaxari.prasannamurthy@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Pawel Moll <Pawel.Moll@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org

---
Below lkml link is a quoting by Russell, which explains more on concept of
PHYS_VIRT and ZRELADDR
-------------------------------------------------

https://lkml.org/lkml/2011/10/14/434

-------------------------------------------------
---
 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3dfc3b8..077ef9d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -332,6 +332,7 @@ config ARCH_REALVIEW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARM_AMBA
 	select ARM_TIMER_SP804
+	select AUTO_ZRELADDR
 	select COMMON_CLK
 	select COMMON_CLK_VERSATILE
 	select GENERIC_CLOCKEVENTS
-- 
1.7.10.4

