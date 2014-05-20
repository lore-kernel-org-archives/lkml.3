Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaETLej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:34:39 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:59163 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbaETLei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:34:38 -0400
Message-ID: <1400585676.4912.38.camel@x220>
Subject: [PATCH] MIPS: remove CONFIG_PMCTWILED completely
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 13:34:36 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 11:34:36.0579 (UTC) FILETIME=[7A8B4730:01CF741F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8b284dbc2200 ("MIPS: PNX Removing dead CONFIG_PMCTWILED") missed
one reference to CONFIG_PMCTWILED in the code. It also missed one
related reference to pmctwiled_setup(). Remove these references now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/mips/pmcs-msp71xx/msp_setup.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/mips/pmcs-msp71xx/msp_setup.c b/arch/mips/pmcs-msp71xx/msp_setup.c
index 7e980767679c..ba9d518dc624 100644
--- a/arch/mips/pmcs-msp71xx/msp_setup.c
+++ b/arch/mips/pmcs-msp71xx/msp_setup.c
@@ -27,7 +27,6 @@
 #endif
 
 extern void msp_serial_setup(void);
-extern void pmctwiled_setup(void);
 
 #if defined(CONFIG_PMC_MSP7120_EVAL) || \
     defined(CONFIG_PMC_MSP7120_GW) || \
@@ -235,12 +234,4 @@ void __init prom_init(void)
 		register_smp_ops(&msp_smtc_smp_ops);
 #endif
 	}
-
-#ifdef CONFIG_PMCTWILED
-	/*
-	 * Setup LED states before the subsys_initcall loads other
-	 * dependent drivers/modules.
-	 */
-	pmctwiled_setup();
-#endif
 }
-- 
1.9.0

