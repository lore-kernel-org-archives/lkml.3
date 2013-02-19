Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab3BSPUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:20:46 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:59891 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab3BSPUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:20:45 -0500
Message-ID: <1361287233.23734.1.camel@phoenix>
Subject: [PATCH] mfd: Make AB8500_CORE select POWER_SUPPLY to fix build error
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Feb 2013 23:20:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below build error when CONFIG_POWER_SUPPLY is not set.

drivers/built-in.o: In function `ab8500_power_off':
drivers/mfd/ab8500-sysctrl.c:37: undefined reference to `power_supply_get_by_name'
drivers/mfd/ab8500-sysctrl.c:53: undefined reference to `power_supply_get_by_name'
make: *** [vmlinux] Error 1

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 671f5b1..c346941 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -858,6 +858,7 @@ config EZX_PCAP
 config AB8500_CORE
 	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
 	depends on GENERIC_HARDIRQS && ABX500_CORE && MFD_DB8500_PRCMU
+	select POWER_SUPPLY
 	select MFD_CORE
 	select IRQ_DOMAIN
 	help
-- 
1.7.9.5



