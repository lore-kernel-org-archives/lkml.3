Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaIHCWH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 22:22:07 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:22158 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaIHCWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 22:22:05 -0400
Date: Mon, 8 Sep 2014 04:21:59 +0200 (CEST)
From: robert.jarzmik@free.fr
To: Arnd Bergmann <arnd@arndb.de>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        arm@kernel.org
Message-ID: <2043099673.69233100.1410142919959.JavaMail.root@zimbra1-e1.priv.proxad.net>
In-Reply-To: <3188925.pjYA4K7kjn@wuerfel>
Subject: =?utf-8?Q?Re=C2=A0:_Re:_[PATCH_]_ARM:_pxa:_fix_section_?=
 =?utf-8?Q?mismatch_warning_for_pxa=5Ftimer=5Fnodt=5Finit?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [32.145.84.193]
X-Mailer: Zimbra 7.2.0-GA2598 (zclient/7.2.0-GA2598)
X-Authenticated-User: robert.jarzmik@free.fr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes please Arnd, I'm still out for 1.5 week, so it would be great if you take that through your tree with my ack. Thanks.

Robert

PS: I know, top-posting is madness, but I'm really limited by technology right now.

----- Mail d'origine -----
De: Arnd Bergmann <arnd@arndb.de>
À: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, arm@kernel.org
Envoyé: Sun, 07 Sep 2014 23:06:05 +0200 (CEST)
Objet: Re: [PATCH ] ARM: pxa: fix section mismatch warning for pxa_timer_nodt_init

On Saturday 26 July 2014 20:50:36 Arnd Bergmann wrote:
> commit a38b1f60b5245a3 ("ARM: pxa: Add non device-tree timer link to
> clocksource") introduced a harmless section mismatch warning for
> all pxa platforms, by introducing a new pxa_timer_init() function
> that is not marked __init but that calls pxa_timer_nodt_init(),
> which is. The function is only called at init time, so it is safe
> to also annotate it this way.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 

Apparently this is not merged yet, should we take it through arm-soc?

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

