Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaAIPCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:02:07 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:6461 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaAIPB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:01:56 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        ARM Maintainers <arm@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        stable <stable@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: smc: bug fix in sam9_smc_cs_read()
Date: Thu, 9 Jan 2014 16:01:54 +0100
Message-ID: <1389279714-30873-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

There was a copy/paste error when reading the nwe_pulse value.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: stable <stable@vger.kernel.org> # 3.3
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Arnd, Olof, Kevin,

This is a little fix that I have just received. As the "fixes" colletion is
certainly closed for 3.13, I would like to include this one in the
"fixes-non-critical" topic for 3.14.

For the time being, I only have this one, so It can be convenient if you take
this fix as a patch instead of a pull-request.

Thanks, bye,
  Nicolas Ferre

 arch/arm/mach-at91/sam9_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/sam9_smc.c b/arch/arm/mach-at91/sam9_smc.c
index 99a0a1d2b7dc..b26156bf15db 100644
--- a/arch/arm/mach-at91/sam9_smc.c
+++ b/arch/arm/mach-at91/sam9_smc.c
@@ -101,7 +101,7 @@ static void sam9_smc_cs_read(void __iomem *base,
 	/* Pulse register */
 	val = __raw_readl(base + AT91_SMC_PULSE);
 
-	config->nwe_setup = val & AT91_SMC_NWEPULSE;
+	config->nwe_pulse = val & AT91_SMC_NWEPULSE;
 	config->ncs_write_pulse = (val & AT91_SMC_NCS_WRPULSE) >> 8;
 	config->nrd_pulse = (val & AT91_SMC_NRDPULSE) >> 16;
 	config->ncs_read_pulse = (val & AT91_SMC_NCS_RDPULSE) >> 24;
-- 
1.8.2.2

