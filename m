Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3IYXXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:23:33 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:54001 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab3IYXX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:23:29 -0400
Message-ID: <52437062.5040705@elopez.com.ar>
Date: Wed, 25 Sep 2013 20:23:14 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-arm-kernel@lists.infradead.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] clocksource: Add Allwinner SoCs HS timers driver
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com> <1380117790-19390-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1380117790-19390-3-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 25/09/13 11:03, Maxime Ripard escribió:
> Most of the Allwinner SoCs (at this time, all but the A10) also have a
> High Speed timers that are not using the 24MHz oscillator as a source
> but rather the AHB clock running much faster.
>
> The IP is slightly different between the A10s/A13 and the one used in
> the A20/A31, since the latter have 4 timers available, while the former
> have only 2 of them.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---

[...]

> +static void __init sun5i_timer_init(struct device_node *node)
> +{
> +	unsigned long rate;
> +	struct clk *clk;
> +	int ret, irq;
> +	u32 val;
> +
> +	timer_base = of_iomap(node, 0);
> +	if (!timer_base)
> +		panic("Can't map registers");
> +
> +	irq = irq_of_parse_and_map(node, 0);
> +	if (irq <= 0)
> +		panic("Can't parse IRQ");
> +
> +	clk = of_clk_get(node, 0);
> +	if (IS_ERR(clk))
> +		panic("Can't get timer clock");

I'm not familiar with clocksources, but does this have to be as fatal as 
it is considering the kernel also supports the slower sun4i timer?

Also, would any special considerations be needed when adjusting the ahb 
clock? A future cpufreq driver will most likely need to.

Cheers,

Emilio
