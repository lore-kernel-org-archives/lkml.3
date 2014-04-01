Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaDAL6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:58:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaDALRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrea Adami <andrea.adami@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 063/144] ARM: 7991/1: sa1100: fix compile problem on Collie
Date: Tue,  1 Apr 2014 12:14:27 +0100
Message-Id: <1396350948-29910-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 052450fdc55894a39fbae93d9bbe43947956f663 upstream.

Due to a problem in the MFD Kconfig it was not possible to
compile the UCB battery driver for the Collie SA1100 system,
in turn making it impossible to compile in the battery driver.
(See patch "mfd: include all drivers in subsystem menu".)

After fixing the MFD Kconfig (separate patch) a compile error
appears in the Collie battery driver due to the <mach/collie.h>
implicitly requiring <mach/hardware.h> through <linux/gpio.h>
via <mach/gpio.h> prior to commit
40ca061b "ARM: 7841/1: sa1100: remove complex GPIO interface".

Fix this up by including the required header into
<mach/collie.h>.

Cc: Andrea Adami <andrea.adami@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-sa1100/include/mach/collie.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-sa1100/include/mach/collie.h b/arch/arm/mach-sa1100/include/mach/collie.h
index f33679d..50e1d85 100644
--- a/arch/arm/mach-sa1100/include/mach/collie.h
+++ b/arch/arm/mach-sa1100/include/mach/collie.h
@@ -13,6 +13,8 @@
 #ifndef __ASM_ARCH_COLLIE_H
 #define __ASM_ARCH_COLLIE_H
 
+#include "hardware.h" /* Gives GPIO_MAX */
+
 extern void locomolcd_power(int on);
 
 #define COLLIE_SCOOP_GPIO_BASE	(GPIO_MAX + 1)
-- 
1.9.1

