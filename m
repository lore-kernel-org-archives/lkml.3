Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab3GFAMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 20:12:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:47427 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3GFAM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 20:12:29 -0400
Date: Sat, 6 Jul 2013 02:12:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Heiko_St=FCbner?= <heiko@sntech.de>
cc: John Stultz <john.stultz@linaro.org>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
Subject: Re: [PATCH 9/9] clocksource: dw_apb_timer: special variant for
 rockchip rk3188 timers
In-Reply-To: <201307060056.29370.heiko@sntech.de>
Message-ID: <alpine.DEB.2.02.1307060153110.32106@ionos.tec.linutronix.de>
References: <201307060051.09716.heiko@sntech.de> <201307060056.29370.heiko@sntech.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1635963963-1373069545=:32106"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1635963963-1373069545=:32106
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sat, 6 Jul 2013, Heiko Stübner wrote:
> +	if (of_device_is_compatible(np, "rockchip,rk3188-dw-apb-timer-osc"))
> +		*quirks |= APBTMR_QUIRK_64BIT_COUNTER | APBTMR_QUIRK_NO_EOI |
> +			   APBTMR_QUIRK_INVERSE_INTMASK |
> +			   APBTMR_QUIRK_INVERSE_PERIODIC;

Brilliant. Next time we add

> +	if (of_device_is_compatible(np, "rockchip,rk3188-dw-apb-timer-osc2"))
> +		*quirks |= APBTMR_QUIRK_64BIT_COUNTER | APBTMR_QUIRK_NO_EOI |
> +			   APBTMR_QUIRK_INVERSE_INTMASK |
> +			   APBTMR_QUIRK_INVERSE_PERIODIC | MORE_NONSENSE;

Plus the extra conditionals all over the place

and a week later

> +	if (of_device_is_compatible(np, "rockchip,rk3188-dw-apb-timer-osc3"))
> +		*quirks |= ALLNONSENSE;


This has nothing to do with QUIRKS at all. QUIRKS are our last resort
when we cannot deal with the problem in a sane way.

In this case this is simply the wrong aproach.

We can deal with it in a sane way as I pointed out before and handle
it as simple properties of the IP block. We have all mechanisms in
place to handle such properties, device tree, platform data, static
init structures. It's all there and we really do not need to plaster
the code with random QUIRK conditionals.

Did you ever consider the runtime penalty of this? Probably not,
otherwise you would have spent time on speeding up that code by
caching frequently accessed registers instead of reading them back
over and over for no reason.

Thanks,

	tglx

--8323329-1635963963-1373069545=:32106--
