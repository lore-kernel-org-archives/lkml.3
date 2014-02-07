Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbaBGMi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:38:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42009 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbaBGLul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Kevin Hilman <khilman@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 128/233] ARM: at91: smc: bug fix in sam9_smc_cs_read()
Date: Fri,  7 Feb 2014 11:45:47 +0000
Message-Id: <1391773652-25214-129-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

commit 1588c51cf6d782e63a8719681d905ef0ac22ee62 upstream.

There was a copy/paste error when reading the nwe_pulse value.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-at91/sam9_smc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/sam9_smc.c b/arch/arm/mach-at91/sam9_smc.c
index 99a0a1d..b26156b 100644
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
1.8.3.2

