Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaIGVGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 17:06:45 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53473 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaIGVGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 17:06:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        arm@kernel.org
Subject: Re: [PATCH ] ARM: pxa: fix section mismatch warning for pxa_timer_nodt_init
Date: Sun, 07 Sep 2014 23:06:05 +0200
Message-ID: <3188925.pjYA4K7kjn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <12220413.BdRleC0Xf5@wuerfel>
References: <1405356724-32207-1-git-send-email-robert.jarzmik@free.fr> <87oawivarv.fsf@free.fr> <12220413.BdRleC0Xf5@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:+g/6DcdkH2ICxbdH8vv4tkWzTVfnjIy8tnqElAqfRQC
 snOaNufC8GAFc7LcPEfE4f9JLWj2zgR06twru1peo+ofIx1YNY
 GI9s70dVacGMqjyryW/9F+K2xvuDMuxb+i7vRDNYG5/n82kBV2
 iyvsJwj0qNckmDahColCe2vbJWMyvgGkci9SXoiOayu2NZJApY
 stBlkcka27xEd8bnvOHwx5mA6Qs1toJFwRlCsJgEB4F1CNwCYi
 lg8EBX1X8kv4HNsMmivfHlM76O3wgYLkACeshiZWxPJniDRhy3
 qYff1Z66FanlubPrCFpUW42NbDDZTS6xGaqtcpYXELyFxmjtxk
 QnmvbgxHhJfcnrk+CzFQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
