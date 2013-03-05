Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab3CERax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 12:30:53 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:55368 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755535Ab3CERaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 12:30:52 -0500
Message-ID: <1362504650.16460.95.camel@x61.thuisdomein>
Subject: [PATCH] m68k: drop "select EMAC_INC"
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 18:30:50 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 17:30:51.0635 (UTC) FILETIME=[2EE63C30:01CE19C7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow this select statement managed to squeeze itself between commit
0e152d80507b75c00aac60f2ffc586360687cd52 ("m68k: reorganize Kconfig
options to improve mmu/non-mmu selections") and commit
95e82747d6e2abc513bfae416e6009968985d05b ("m68k: drop unused Kconfig
symbols"). Whatever happened, there is no Kconfig symbol named EMAC_INC.
The select statement for that symbol is a nop. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested, but it's hard to see what can got wrong here.

 arch/m68k/Kconfig.machine | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/m68k/Kconfig.machine b/arch/m68k/Kconfig.machine
index 7cdf6b0..7240584 100644
--- a/arch/m68k/Kconfig.machine
+++ b/arch/m68k/Kconfig.machine
@@ -310,7 +310,6 @@ config COBRA5282
 config SOM5282EM
 	bool "EMAC.Inc SOM5282EM board support"
 	depends on M528x
-	select EMAC_INC
 	help
 	  Support for the EMAC.Inc SOM5282EM module.
 
-- 
1.7.11.7

