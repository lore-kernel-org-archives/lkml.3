Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab3FNJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:56:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45683 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab3FNJ4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:56:13 -0400
From: Philip Avinash <avinashphilipk@gmail.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>,
        Philip Avinash <avinashphilipk@gmail.com>
Subject: [PATCH 1/2] ARM: davinci: fix for build breakage for tnetv107x platforms
Date: Fri, 14 Jun 2013 15:27:48 +0530
Message-ID: <1371203869-16308-2-git-send-email-avinashphilipk@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371203869-16308-1-git-send-email-avinashphilipk@gmail.com>
References: <1371203869-16308-1-git-send-email-avinashphilipk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build breakage and section mismatch error. This build
break will comes only on removal of NEED_MACH_GPIO_H select option for
ARCH-DAVINCI.

arch/arm/mach-davinci/board-tnetv107x-evm.c:283:15: error:
'davinci_timer_init' undeclared here (not in a function)
arch/arm/mach-davinci/board-tnetv107x-evm.c:285:15: error:
'davinci_init_late' undeclared here (not in a function)
make[1]: *** [arch/arm/mach-davinci/board-tnetv107x-evm.o] Error 1

Signed-off-by: Philip Avinash <avinashphilipk@gmail.com>
---
 arch/arm/mach-davinci/board-tnetv107x-evm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index ba79837..b5db980 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -30,6 +30,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
 
+#include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/edma.h>
 #include <mach/mux.h>
@@ -147,7 +148,7 @@ static struct davinci_nand_pdata nand_config = {
 	.ecc_bits	= 1,
 };
 
-static struct davinci_uart_config serial_config __initconst = {
+static struct davinci_uart_config serial_config __initdata = {
 	.enabled_uarts	= BIT(1),
 };
 
@@ -245,7 +246,7 @@ static struct ti_ssp_data ssp_config = {
 	},
 };
 
-static struct tnetv107x_device_info evm_device_info __initconst = {
+static struct tnetv107x_device_info evm_device_info __initdata = {
 	.serial_config		= &serial_config,
 	.mmc_config[1]		= &mmc_config,	/* controller 1 */
 	.nand_config[0]		= &nand_config,	/* chip select 0 */
-- 
1.7.9.5

