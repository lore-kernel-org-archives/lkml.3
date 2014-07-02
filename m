Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbaGBQJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:09:13 -0400
Received: from helium.waldemar-brodkorb.de ([89.238.66.15]:52628 "EHLO
	helium.waldemar-brodkorb.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbaGBQJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:09:12 -0400
Date: Wed, 2 Jul 2014 18:09:08 +0200
From: Waldemar Brodkorb <wbx@openadk.org>
To: Linux MIPS Mailing List <linux-mips@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        florian@openwrt.org
Subject: [PATCH] fix reregistering of serial console
Message-ID: <20140702160908.GA12510@waldemar-brodkorb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: Linux 3.2.0-4-amd64 x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Runtime tested on Mikrotik RB532 board.
Thanks goes to Geert Uytterhoeven for the explanation of the problem.

"I'm afraid this is not gonna help. When the port is unregistered,
its type will be reset to PORT_UNKNOWN.
So before registering it again, its type must be set again the actual
serial driver, cfr. the change to of_serial.c."

Signed-off-by: Waldemar Brodkorb <wbx@openadk.org>
---
 arch/mips/rb532/devices.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
index 3af00b2..ba61268 100644
--- a/arch/mips/rb532/devices.c
+++ b/arch/mips/rb532/devices.c
@@ -223,6 +223,7 @@ static struct platform_device rb532_wdt = {
 
 static struct plat_serial8250_port rb532_uart_res[] = {
 	{
+		.type           = PORT_16550A,
 		.membase	= (char *)KSEG1ADDR(REGBASE + UART0BASE),
 		.irq		= UART0_IRQ,
 		.regshift	= 2,
-- 
1.7.10.4

