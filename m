Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbaGES34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 14:29:56 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:60443 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaGES3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 14:29:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, devicetree@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] arm: pxa: add non device-tree timer link to clocksource
Date: Sat, 05 Jul 2014 20:29:40 +0200
Message-ID: <5284586.j08GjTMeo6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404558781-9537-4-git-send-email-robert.jarzmik@free.fr>
References: <1404558781-9537-1-git-send-email-robert.jarzmik@free.fr> <1404558781-9537-4-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uA1nmEX78BnvJxBDQ65yZVaGOse9tQKc2RhhYf9KEwX
 2ohJyqTyLfXrnz6KpWUjg9Lyd7XoBeyVhIHSv6fYl05HACbgDV
 gPtGhiBe309cbXa2XBVlOJ5XrUPf+w2cOJi3FIsYZdg0yNaZyf
 EPt7Lhl7rCmpU7OHrI8Zkh8OBHlclWGR0t8+rs3kEewDbFXfeb
 FB9vD+4x/Mlcrsl79+BbBCsPFj1/OIWcOjBAt1V6RwXHmmA/1G
 BaqFkiFZO/X4HZjVUyNJtvR9n5h6WFeJcV+X+iG3m/7k5OMg+e
 5eMVBGaRwy1hcnrzEeGT5gau6O2GXhCmudO4uSXn1sXOEq3hFE
 5GQZAXpNNBkouGl5sd8E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 July 2014 13:13:01 Robert Jarzmik wrote:
>  EXPORT_SYMBOL(get_clock_tick_rate);
>  
>  /*
> + * For non device-tree builds, keep legacy timer init
> + */
> +extern void pxa_timer_nodt_init(int irq, void __iomem *base,
> +                          unsigned long clock_tick_rate);
> +void pxa_timer_init(void)
> +{
> +       pxa_timer_nodt_init(IRQ_OST0, io_p2v(0x40a00000),
> +                           get_clock_tick_rate());
> +}
> +

I think it would be better to move the extern declaration into 
a new header file, e.g. include/clocksource/pxa.h.

	Arnd
