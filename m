Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaEOKRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:17:10 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:50376 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbaEOKRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:17:07 -0400
Message-ID: <1400149025.20469.22.camel@x220>
Subject: [PATCH] ARM: davinci: remove checks for CONFIG_USB_MUSB_PERIPHERAL
From: Paul Bolle <pebolle@tiscali.nl>
To: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Date: Thu, 15 May 2014 12:17:05 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 May 2014 10:17:05.0665 (UTC) FILETIME=[D2515F10:01CF7026]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol USB_MUSB_PERIPHERAL was removed in v3.1. The last two
checks for its macro now always evaluate to false. So remove these
checks.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Eyeball tested only.

This is just a straightforward cleanup. It does remove a comment. Is
that comment still useful? Anyhow, I do wonder whether a proper fix is
possible here. Perhaps Greg or Felipe knows: it is their commit
622859634a66 ("usb: musb: drop a gigantic amount of ifdeferry") that
removed USB_MUSB_PERIPHERAL. On the other hand I noticed that config
USB_MUSB_DAVINCI depends on BROKEN. So maybe properly fixing just this
small problem doesn't buy us much.

 arch/arm/mach-davinci/board-dm355-evm.c     | 4 ----
 arch/arm/mach-davinci/board-dm355-leopard.c | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index ecdc7d44fa70..06d63d5651f3 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -350,11 +350,7 @@ static struct davinci_mmc_config dm355evm_mmc_config = {
  * you have proper Mini-B or Mini-A cables (or Mini-A adapters)
  * the ID pin won't need any help.
  */
-#ifdef CONFIG_USB_MUSB_PERIPHERAL
-#define USB_ID_VALUE	0	/* ID pulled high; *should* float */
-#else
 #define USB_ID_VALUE	1	/* ID pulled low */
-#endif
 
 static struct spi_eeprom at25640a = {
 	.byte_len	= SZ_64K / 8,
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index 43bacbf15314..680a7a2d9102 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -208,11 +208,7 @@ static struct davinci_mmc_config dm355leopard_mmc_config = {
  * you have proper Mini-B or Mini-A cables (or Mini-A adapters)
  * the ID pin won't need any help.
  */
-#ifdef CONFIG_USB_MUSB_PERIPHERAL
-#define USB_ID_VALUE	0	/* ID pulled high; *should* float */
-#else
 #define USB_ID_VALUE	1	/* ID pulled low */
-#endif
 
 static struct spi_eeprom at25640a = {
 	.byte_len	= SZ_64K / 8,
-- 
1.9.0

