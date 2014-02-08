Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaBHVrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 16:47:01 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:51553 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022AbaBHVrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 16:47:00 -0500
Message-ID: <1391896018.19595.12.camel@x220>
Subject: [PATCH] MIPS: no need to select ARCH_SUPPORTS_MSI
From: Paul Bolle <pebolle@tiscali.nl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Jayachandran C <jchandra@broadcom.com>, John Crispin <blogic@openwrt.org>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Sat, 08 Feb 2014 22:46:58 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2014 21:46:58.0653 (UTC) FILETIME=[4ACE18D0:01CF2517]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c24a8a7a9988 ("MIPS: Netlogic: Add MSI support for XLP") added
"select ARCH_SUPPORTS_MSI". But the Kconfig symbol ARCH_SUPPORTS_MSI was
already removed in v3.12, so that select is a nop. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

It was commit ebd97be635bf ("PCI: remove ARCH_SUPPORTS_MSI kconfig
option") that removed this Kconfig symbol.

 arch/mips/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index dcae3a7..b3bf596 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -782,7 +782,6 @@ config NLM_XLP_BOARD
 	select CEVT_R4K
 	select CSRC_R4K
 	select IRQ_CPU
-	select ARCH_SUPPORTS_MSI
 	select ZONE_DMA32 if 64BIT
 	select SYNC_R4K
 	select SYS_HAS_EARLY_PRINTK
-- 
1.8.5.3

