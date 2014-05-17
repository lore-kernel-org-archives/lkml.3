Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbaEQLxL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 07:53:11 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:51849 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932247AbaEQLxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 07:53:10 -0400
Message-ID: <1400327586.13824.10.camel@x220>
Subject: [PATCH] Hexagon: remove check for CONFIG_COMET_EARLY_UART_DEBUG
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 17 May 2014 13:53:06 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 May 2014 11:53:07.0567 (UTC) FILETIME=[918157F0:01CF71C6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's been a check for CONFIG_COMET_EARLY_UART_DEBUG ever since
Hexagon was added in v3.2. But the related Kconfig symbol has never been
added to the tree. Remove this check.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Not tested.

 arch/hexagon/kernel/vm_init_segtable.S | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/hexagon/kernel/vm_init_segtable.S b/arch/hexagon/kernel/vm_init_segtable.S
index 80967f2192b3..167b48458620 100644
--- a/arch/hexagon/kernel/vm_init_segtable.S
+++ b/arch/hexagon/kernel/vm_init_segtable.S
@@ -85,12 +85,7 @@ swapper_pg_dir:
 	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
 	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
 /*0xa8*/.word X,X,X,X
-#ifdef CONFIG_COMET_EARLY_UART_DEBUG
-UART_PTE_ENTRY:
-/*0xa9*/.word BKPG_IO(0xa9000000),BKPG_IO(0xa9000000),BKPG_IO(0xa9000000),BKPG_IO(0xa9000000)
-#else
 /*0xa9*/.word X,X,X,X
-#endif
 /*0xaa*/.word X,X,X,X
 /*0xab*/.word X,X,X,X
 /*0xac*/.word X,X,X,X
-- 
1.9.0

