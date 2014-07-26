Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaGZSvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 14:51:14 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59794 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaGZSvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 14:51:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH ] ARM: pxa: fix section mismatch warning for pxa_timer_nodt_init
Date: Sat, 26 Jul 2014 20:50:36 +0200
Message-ID: <12220413.BdRleC0Xf5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <87oawivarv.fsf@free.fr>
References: <1405356724-32207-1-git-send-email-robert.jarzmik@free.fr> <53CD25A4.7030606@linaro.org> <87oawivarv.fsf@free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GWZqI0SpFg7aSLxoKBHiddXqeZJN0Z9Rb3HKhc7jjgy
 l+35bszetPWHRSOkxu3HV8mXVlm2wpi2BexT/cRmxxnCcqU6C1
 ZU8Lhc+UIGD4W4KSRfl03aW41f4IuF2su0H2X5EkNosTQeNf/K
 o3apbyts0E3J37cy0Tbk4ZxRKV29qJ6+VTxmj+ksQMNKsuhb2I
 6UTQTIW+Zr2qpgrrpj1b2cdeg8RjaJdu+VRiJf/W9pypJVAKMH
 0IczDbuoJ5VFUNbfVSkfx3ltNnkT3HG2G+MIoegs50KRQi5Z2F
 q3oTXs1aZHgUF5x74k2QRiZqZ44NUsOPq4o6jUkVujZnwAEnWd
 IQ3rVR+Fd9nFEjrNoOI8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a38b1f60b5245a3 ("ARM: pxa: Add non device-tree timer link to
clocksource") introduced a harmless section mismatch warning for
all pxa platforms, by introducing a new pxa_timer_init() function
that is not marked __init but that calls pxa_timer_nodt_init(),
which is. The function is only called at init time, so it is safe
to also annotate it this way.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Daniel, please apply on top of Robert's patch series.

diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
index 630fa916bbc6..04b013fbc98f 100644
--- a/arch/arm/mach-pxa/generic.c
+++ b/arch/arm/mach-pxa/generic.c
@@ -61,7 +61,7 @@ EXPORT_SYMBOL(get_clock_tick_rate);
 /*
  * For non device-tree builds, keep legacy timer init
  */
-void pxa_timer_init(void)
+void __init pxa_timer_init(void)
 {
 	pxa_timer_nodt_init(IRQ_OST0, io_p2v(0x40a00000),
 			    get_clock_tick_rate());

