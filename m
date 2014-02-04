Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992AbaBDVBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:01:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802AbaBDVAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:00:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 3.4 20/37] ARM: at91: smc: bug fix in sam9_smc_cs_read()
Date: Tue,  4 Feb 2014 13:00:56 -0800
Message-Id: <20140204210056.582017248@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210055.992134150@linuxfoundation.org>
References: <20140204210055.992134150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

commit 1588c51cf6d782e63a8719681d905ef0ac22ee62 upstream.

There was a copy/paste error when reading the nwe_pulse value.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/sam9_smc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-at91/sam9_smc.c
+++ b/arch/arm/mach-at91/sam9_smc.c
@@ -101,7 +101,7 @@ static void sam9_smc_cs_read(void __iome
 	/* Pulse register */
 	val = __raw_readl(base + AT91_SMC_PULSE);
 
-	config->nwe_setup = val & AT91_SMC_NWEPULSE;
+	config->nwe_pulse = val & AT91_SMC_NWEPULSE;
 	config->ncs_write_pulse = (val & AT91_SMC_NCS_WRPULSE) >> 8;
 	config->nrd_pulse = (val & AT91_SMC_NRDPULSE) >> 16;
 	config->ncs_read_pulse = (val & AT91_SMC_NCS_RDPULSE) >> 24;


