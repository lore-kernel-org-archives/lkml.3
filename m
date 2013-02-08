Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946740Ab3BHRBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:01:20 -0500
Received: from 4.mo4.mail-out.ovh.net ([178.32.98.131]:37153 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753258Ab3BHRBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:01:19 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2013 12:01:19 EST
Date: Fri, 8 Feb 2013 17:52:24 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        FlorianSchandinat@gmx.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        jhovold@gmail.com, jacmet@sunsite.dk
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH 0/5] at91: atmel_lcdfb: regression fixes and cpu_is
 removal
Message-ID: <20130208165224.GF30595@game.jcrosoft.org>
References: <cover.1360340791.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1360340791.git.nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 3282279705416346476
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeitddrtdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeitddrtdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

on all

Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
On 17:35 Fri 08 Feb     , Nicolas Ferre wrote:
> These patches fix a regression in 16-bpp support for older SOCs which use
> IBGR:555 rather than BGR:565 pixel layout. Use SOC-type to determine if the
> controller uses the intensity-bit and restore the old layout in that case.
> 
> The last patch is a removal of uses of cpu_is_xxxx() macros in atmel_lcdfb with
> a platform-device-id table and static configurations.
> 
> 
> Patches from Johan Hovold taken from:
> "[PATCH 0/3] atmel_lcdfb: fix 16-bpp regression"
> and
> "[PATCH v2 0/3] ARM: at91/avr32/atmel_lcdfb: remove cpu_is macros"
> patch series to form a clean patch series with my signature.
> 
> Arnd, Olof,
> as it seems that old fbdev drivers are not so much reviewed those days, can we
> take the decision to queue this material through arm-soc with other AT91
> drivers updates?
> 
> Best regards,
> 
> Johan Hovold (5):
>   atmel_lcdfb: fix 16-bpp modes on older SOCs
>   ARM: at91/neocore926: fix LCD-wiring mode
>   ARM: at91/avr32/atmel_lcdfb: add bus-clock entry
>   atmel_lcdfb: move lcdcon2 register access to compute_hozval
>   ARM: at91/avr32/atmel_lcdfb: add platform device-id table
> 
>  arch/arm/mach-at91/at91sam9261.c         |   2 +
>  arch/arm/mach-at91/at91sam9261_devices.c |   6 +-
>  arch/arm/mach-at91/at91sam9263.c         |   1 +
>  arch/arm/mach-at91/at91sam9263_devices.c |   2 +-
>  arch/arm/mach-at91/at91sam9g45.c         |   2 +
>  arch/arm/mach-at91/at91sam9g45_devices.c |   6 +-
>  arch/arm/mach-at91/at91sam9rl.c          |   1 +
>  arch/arm/mach-at91/at91sam9rl_devices.c  |   2 +-
>  arch/arm/mach-at91/board-neocore926.c    |   2 +-
>  arch/avr32/mach-at32ap/at32ap700x.c      |   6 +-
>  drivers/video/atmel_lcdfb.c              | 130 ++++++++++++++++++++++++-------
>  include/video/atmel_lcdc.h               |   4 +-
>  12 files changed, 127 insertions(+), 37 deletions(-)
> 
> -- 
> 1.8.0
> 
