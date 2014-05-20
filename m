Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaETIDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:03:53 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:62626 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbaETIDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:03:51 -0400
Message-ID: <1400573029.4912.9.camel@x220>
Subject: [PATCH] m32r: remove check for CONFIG_IDC_AK4524
From: Paul Bolle <pebolle@tiscali.nl>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 10:03:49 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 08:03:50.0313 (UTC) FILETIME=[08C83990:01CF7402]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's been a check for CONFIG_IDC_AK4524 and its MODULE variant in
m32r's code ever since it was added in v2.6.9. But there has never been
a Kconfig symbol IDC_AK4524. Remove this check.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/m32r/platforms/usrv/setup.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/m32r/platforms/usrv/setup.c b/arch/m32r/platforms/usrv/setup.c
index dcde0ec777f6..04af9c2a83d9 100644
--- a/arch/m32r/platforms/usrv/setup.c
+++ b/arch/m32r/platforms/usrv/setup.c
@@ -194,15 +194,6 @@ void __init init_IRQ(void)
 	disable_m32700ut_pld_irq(PLD_IRQ_UART1);
 #endif	/* CONFIG_SERIAL_8250 || CONFIG_SERIAL_8250_MODULE */
 
-#if defined(CONFIG_IDC_AK4524) || defined(CONFIG_IDC_AK4524_MODULE)
-	/* INT#80: AK4524 IREQ on PLD */
-	irq_set_chip_and_handler(PLD_IRQ_SNDINT, &m32700ut_pld_irq_type,
-				 handle_level_irq);
-	pld_icu_data[irq2pldirq(PLD_IRQ_SNDINT)].icucr
-		= PLD_ICUCR_ISMOD01;	/* 'L' level sense */
-	disable_m32700ut_pld_irq(PLD_IRQ_SNDINT);
-#endif	/* CONFIG_IDC_AK4524 || CONFIG_IDC_AK4524_MODULE */
-
 	/*
 	 * INT1# is used for UART, MMC, CF Controller in FPGA.
 	 * We enable it here.
-- 
1.9.0

