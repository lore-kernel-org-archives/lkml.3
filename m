Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3GARzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:55:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:56478 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3GARzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:55:18 -0400
Date: Mon, 1 Jul 2013 19:55:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, john.stultz@linaro.org, u.kleine-koenig@pengutronix.de,
        tomasz.figa@gmail.com, linus.walleij@linaro.org,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de
Subject: Re: [PATCH v4] ARM: clocksource: add support for MOXA ART SoCs
In-Reply-To: <1372687359-18235-1-git-send-email-jonas.jensen@gmail.com>
Message-ID: <alpine.DEB.2.02.1307011953390.4013@ionos.tec.linutronix.de>
References: <1372332203-30228-1-git-send-email-jonas.jensen@gmail.com> <1372687359-18235-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, Jonas Jensen wrote:
> +static int moxart_clkevt_next_event(unsigned long cycles,
> +				    struct clock_event_device *unused)
> +{
> +	u32 u;
> +
> +	u = readl(base + TIMER_CR) & ~TIMEREG_CR_1_ENABLE;

You should cache that value and avoid another readout below. You could
even cache it in general so you avoid all readouts.

> +	writel(u, base + TIMER_CR);
> +	u = readl(base + TIMER1_BASE + REG_COUNT) - cycles;
> +	writel(u, base + TIMER1_BASE + REG_MATCH1);
> +	u = readl(base + TIMER_CR) | TIMEREG_CR_1_ENABLE;
> +	writel(u, base + TIMER_CR);
> +	return 0;
> +}

Thanks,

	tglx
