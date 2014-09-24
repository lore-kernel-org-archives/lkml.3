Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaIXS7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:59:16 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:54982 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316AbaIXS7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:59:14 -0400
Message-ID: <1411585151.19525.29.camel@x220>
Subject: [PATCH] ARM: efm32: drop selecting NO_DMA
From: Paul Bolle <pebolle@tiscali.nl>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 24 Sep 2014 20:59:11 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2014 18:59:12.0366 (UTC) FILETIME=[A10398E0:01CFD829]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for ARCH_EFM32 selects NO_DMA. But that doesn't have
any effect as arm doesn't have a Kconfig entry for NO_DMA. This select
is a nop. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by playing with arch/arm/configs/efm32_defconfig. After "make
oldconfig" the .config contains CONFIG_HAS_DMA=y both before and after
this patch, as is expected.

Actually, the only difference I found in the .config file was that after
this patch the .config file contained
    CONFIG_ARCH_EFM32=y

I have no idea why. Did I botch my test?

 arch/arm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d63e50615e9c..804ddc134c3c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -426,7 +426,6 @@ config ARCH_EFM32
 	select COMMON_CLK
 	select CPU_V7M
 	select GENERIC_CLOCKEVENTS
-	select NO_DMA
 	select NO_IOPORT_MAP
 	select SPARSE_IRQ
 	select USE_OF
-- 
1.9.3

