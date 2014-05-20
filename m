Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaETJzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:55:53 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:52174 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbaETJzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:55:52 -0400
Message-ID: <1400579750.4912.24.camel@x220>
Subject: [PATCH] microblaze: remove check for CONFIG_XILINX_CONSOLE
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 11:55:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 09:55:51.0680 (UTC) FILETIME=[AF077000:01CF7411]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's been a check for CONFIG_XILINX_CONSOLE since v2.6.30. But the
Kconfig symbol XILINX_CONSOLE was never added. Remove this check.

And, since DUMMY_CONSOLE depends on VT, we can now drop the check for
CONFIG_VT.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

Note that xil_con doesn't exit either.

 arch/microblaze/kernel/setup.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index bd422794a651..3a93843d346c 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -71,13 +71,9 @@ void __init setup_arch(char **cmdline_p)
 
 	xilinx_pci_init();
 
-#ifdef CONFIG_VT
-#if defined(CONFIG_XILINX_CONSOLE)
-	conswitchp = &xil_con;
-#elif defined(CONFIG_DUMMY_CONSOLE)
+#if defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
 #endif
-#endif
 }
 
 #ifdef CONFIG_MTD_UCLINUX
-- 
1.9.0

