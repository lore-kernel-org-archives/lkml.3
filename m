Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaETKu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:50:57 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:58893 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbaETKu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:50:56 -0400
Message-ID: <1400583055.4912.28.camel@x220>
Subject: [PATCH] MIPS: remove check for CONFIG_CAVIUM_REPORT_SINGLE_BIT_ECC
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 12:50:55 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 10:50:55.0314 (UTC) FILETIME=[6025FB20:01CF7419]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A check for CONFIG_CAVIUM_REPORT_SINGLE_BIT_ECC was added in v2.6.29,
but without the related Kconfig symbol. Remove this check.

Also remove the test for an "ecc_verbose" kernel parameter. It is
undocumented and has no effect anyway.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

Note that __cvmx_interrupt_ecc_report_single_bit_errors doesn't exist.

 arch/mips/cavium-octeon/setup.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 331b837cec57..953ca85f84fa 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -779,12 +779,6 @@ void __init prom_init(void)
 				MAX_MEMORY = 32ull << 30;
 			if (*p == '@')
 				RESERVE_LOW_MEM = memparse(p + 1, &p);
-		} else if (strcmp(arg, "ecc_verbose") == 0) {
-#ifdef CONFIG_CAVIUM_REPORT_SINGLE_BIT_ECC
-			__cvmx_interrupt_ecc_report_single_bit_errors = 1;
-			pr_notice("Reporting of single bit ECC errors is "
-				  "turned on\n");
-#endif
 #ifdef CONFIG_KEXEC
 		} else if (strncmp(arg, "crashkernel=", 12) == 0) {
 			crashk_size = memparse(arg+12, &p);
-- 
1.9.0

