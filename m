Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab3FCM1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:27:34 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:42408 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab3FCM1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:27:31 -0400
Message-ID: <51AC8BAD.4020607@gmail.com>
Date: Mon, 03 Jun 2013 07:27:25 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC] dw_apb_timer_of: use clocksource_of_init
References: <201306030055.15413.heiko@sntech.de> <201306031146.57611.heiko@sntech.de> <1822564.TIKVDZSzqK@wuerfel> <201306031415.29411.heiko@sntech.de>
In-Reply-To: <201306031415.29411.heiko@sntech.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 07:15 AM, Heiko Stübner wrote:
> dw_apb_timer_init used to search the devicetree for matching timer
> devices, making calls to it from board files necessary.
> 
> Change the dw_apb_timer_init to work with CLOCKSOURCE_OF_DECLARE.
> With this change the function gets called once for each timer node
> and tracks these number of calls to attach clockevent and clocksource
> devices to the nodes.
> 
> Also convert all previous users of dw_apb_timer_init to use
> clocksource_of_init.
> 
> Tested on the upcoming rk3066 code.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Acked-by: Rob Herring <rob.herring@calxeda.com>

But 1 comment:

> @@ -88,7 +88,7 @@ DT_MACHINE_START(PICOXCELL, "Picochip picoXcell")
>  	.map_io		= picoxcell_map_io,
>  	.nr_irqs	= NR_IRQS_LEGACY,
>  	.init_irq	= irqchip_init,
> -	.init_time	= dw_apb_timer_init,
> +	.init_time	= clocksource_of_init,

clocksource_of_init is the default now, so you can just remove this and
the one in socfpga.

Same for irqchip_init BTW, but that's another patch.

Rob

