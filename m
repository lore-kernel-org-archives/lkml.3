Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab3FIQrw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:47:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34450 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3FIQrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:47:51 -0400
Date: Sun, 9 Jun 2013 18:47:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        aaro.koskinen@iki.fi, linux-omap@vger.kernel.org,
        lauri.leukkunen@nokia.com
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130609164745.GB16066@amd.pavel.ucw.cz>
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
 <201306091124.41251@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201306091124.41251@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2013-06-09 11:24:40, Pali Rohár wrote:
> On Sunday 09 June 2013 03:59:44 Pavel Machek wrote:
> > Hi!
> > 
> > I'd like to convert Nokia N900 to device tree.
> > 
> > Unfortunately, serial port is not easily available (very
> > special cable would be needed, does someone know where to get
> > one?) and I don't have BDI (and very special cable would be
> > needed, too).
> > 
> 
> Hello,
> 
> I used serial port only in qemu for debugging. Maybe you can try
> to play with qemu first. Qemu has good n900 HW support.

Yes, qemu is helpful.

For the record: this is how you use it.

KERNEL=/data/l/linux-n900/zImage_dtb
./qflasher -m rx51 -x ./xloader-qemu.bin -s ./secondary-qemu.bin -k $KERNEL -o n900.img -p k=6072

> sd-empty
./qemu-system-arm -s -M n900 -mtdblock n900.img -sd sd-empty -serial
stdio -clock unix -redir tcp:5555:10.0.2.15:22

...and this patch is needed to make it past rx51_init.

Author: Pavel <pavel@ucw.cz>
Date:   Sun Jun 9 18:45:39 2013 +0200

    Comment out errata workaround that breaks qemu.

diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index 938e46f..0ffd7d3 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -108,11 +108,13 @@ static void __init rx51_init(void)
 	rx51_peripherals_init();
 	rx51_camera_init();
 
+#if 0
 #ifdef CONFIG_ARM_ERRATA_430973
 	printk(KERN_INFO "RX-51: Enabling ARM errata 430973 workaround.\n");
 	/* set IBE to 1 */
 	rx51_secure_update_aux_cr(1 << 6, 0);
 #endif
+#endif
 
 	/* Ensure SDRC pins are mux'd for self-refresh */
 	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
