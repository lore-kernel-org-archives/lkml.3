Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaETH4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:56:14 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:51018 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbaETH4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:56:13 -0400
Message-ID: <1400572571.4912.7.camel@x220>
Subject: [PATCH] m68k: remove check for CONFIG_BSEIP
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 09:56:11 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 07:56:12.0161 (UTC) FILETIME=[F7B3C710:01CF7400]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There used to be a Kconfig symbol BSEIP. It was PPC specific and was
removed in v2.6.27. So the check for CONFIG_BSEIP can be removed. This
means a few defines will be removed. None of the macros involved are
used, so no one should care.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/m68k/include/asm/commproc.h | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/arch/m68k/include/asm/commproc.h b/arch/m68k/include/asm/commproc.h
index 66a36bd51aa1..c67e09279ea9 100644
--- a/arch/m68k/include/asm/commproc.h
+++ b/arch/m68k/include/asm/commproc.h
@@ -480,28 +480,6 @@ typedef struct scc_enet {
 #define SICR_ENET_CLKRT	((uint)0x0000003d)
 #endif
 
-#ifdef CONFIG_BSEIP
-/* This ENET stuff is for the MPC823 with ethernet on SCC2.
- * This is unique to the BSE ip-Engine board.
- */
-#define PA_ENET_RXD	((ushort)0x0004)
-#define PA_ENET_TXD	((ushort)0x0008)
-#define PA_ENET_TCLK	((ushort)0x0100)
-#define PA_ENET_RCLK	((ushort)0x0200)
-#define PB_ENET_TENA	((uint)0x00002000)
-#define PC_ENET_CLSN	((ushort)0x0040)
-#define PC_ENET_RENA	((ushort)0x0080)
-
-/* BSE uses port B and C bits for PHY control also.
-*/
-#define PB_BSE_POWERUP	((uint)0x00000004)
-#define PB_BSE_FDXDIS	((uint)0x00008000)
-#define PC_BSE_LOOPBACK	((ushort)0x0800)
-
-#define SICR_ENET_MASK	((uint)0x0000ff00)
-#define SICR_ENET_CLKRT	((uint)0x00002c00)
-#endif
-
 /* SCC Event register as used by Ethernet.
 */
 #define SCCE_ENET_GRA	((ushort)0x0080)	/* Graceful stop complete */
-- 
1.9.0

