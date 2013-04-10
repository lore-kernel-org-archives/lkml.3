Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936941Ab3DJJ0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:26:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57412 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936586Ab3DJJ0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:26:11 -0400
Date: Wed, 10 Apr 2013 11:26:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2] New Nokia RX-51 power supply battery driver
Message-ID: <20130410092606.GA16074@amd.pavel.ucw.cz>
References: <19040462.WFXWijAIDd@pali>
 <20130330183526.GA21198@lizard>
 <20130330214229.GA4322@amd.pavel.ucw.cz>
 <201303302351.06611@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303302351.06611@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> open source flasher 0xFFFF (working on x86-64 too) which can load 
> kernel and initfs via usb to n900 RAM without flashing nand:
> https://gitorious.org/0xffff/0xffff

Well, it compiles, and seems to work. Includes extensive
documentation, but...

How do I put the device into mode where it responds to 0xffff? It
seems to be there for only a second after power off...?

n90- has very confusing startup sequence...

> If you need help with booting some upstream kernel on n900 join 
> to freenode #maemo-alternatives channel :-)

Hmm, I did, seems I'm alone there :-(.
									Pavel
PS: I seem to need attached patches to get defconfig to compile:

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 9fe4bdf..4aa13ce 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -1037,7 +1037,7 @@ static struct hsi_board_info __initdata rx51_ssi_cl[] = {
 			.mode = HSI_MODE_FRAME,
 			.channels = 4,
 			.speed = 55000,
-			.arb_mode = HSI_ARB_RR,
+//			.arb_mode = HSI_ARB_RR,
 			},
 		.rx_cfg = {
 			.mode = HSI_MODE_FRAME,
diff --git a/arch/arm/mach-omap2/board-rx51-smc.S b/arch/arm/mach-omap2/board-rx51-smc.S
index 70e2eb7..bdfb2d7 100644
--- a/arch/arm/mach-omap2/board-rx51-smc.S
+++ b/arch/arm/mach-omap2/board-rx51-smc.S
@@ -20,7 +20,7 @@
  *          with number of parametrs
  */
 ENTRY(rx51_ppa_smc)
-	.arch_extension sec
+//	.arch_extension sec
 	stmfd	sp!, {r4-r12, lr}
 	mov	r12, r0		@ Copy the secure service ID
 	mov	r3, r2		@ Copy the pointer to va_list in R3
diff --git a/drivers/char/hw_random/omap3-rom-asm.S b/drivers/char/hw_random/omap3-rom-asm.S
index ce82e16..65d2b5e 100644
--- a/drivers/char/hw_random/omap3-rom-asm.S
+++ b/drivers/char/hw_random/omap3-rom-asm.S
@@ -12,7 +12,7 @@
 #include <asm/assembler.h>
 
 ENTRY(omap3_rng_call_rom_asm)
-	.arch_extension sec
+//	.arch_extension sec
 	stmfd	sp!, {r4-r12, lr}
 	stmfd	sp!, {r0-r3}
 	bl	v7_flush_dcache_all

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
