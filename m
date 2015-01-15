Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbbAOWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:16:57 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57852 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932463AbbAOWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:16:54 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 4/5] ARM: at91: sama5d4: copy defines to SoC file
Date: Thu, 15 Jan 2015 23:16:48 +0100
Message-Id: <1421360209-15852-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421360209-15852-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421360209-15852-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy the defines to the SoC file to remove the need for the header.
The header has to stay for now because on mach/uncompress.h

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/sama5d4.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/sama5d4.c b/arch/arm/mach-at91/sama5d4.c
index 2ec43ee3f440..56d67d620764 100644
--- a/arch/arm/mach-at91/sama5d4.c
+++ b/arch/arm/mach-at91/sama5d4.c
@@ -12,11 +12,21 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
-#include <mach/sama5d4.h>
 #include <mach/hardware.h>
 
 #include "generic.h"
 
+/*
+ * User Peripheral physical base addresses.
+ */
+#define SAMA5D4_BASE_USART3	0xfc00c000 /* (USART3 non-secure) Base Address */
+#define SAMA5D4_BASE_PMC	0xf0018000 /* (PMC) Base Address */
+#define SAMA5D4_BASE_MPDDRC	0xf0010000 /* (MPDDRC) Base Address */
+#define SAMA5D4_BASE_PIOD	0xfc068000 /* (PIOD) Base Address */
+
+/* Some other peripherals */
+#define SAMA5D4_BASE_SYS2	SAMA5D4_BASE_PIOD
+
 static struct map_desc at91_io_desc[] __initdata = {
 	{
 	.virtual        = (unsigned long)AT91_ALT_IO_P2V(SAMA5D4_BASE_MPDDRC),
-- 
2.1.0

