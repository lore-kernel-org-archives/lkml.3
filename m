Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbbAZJna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:43:30 -0500
Received: from www.linutronix.de ([62.245.132.108]:45117 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbbAZJn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:43:27 -0500
Date: Mon, 26 Jan 2015 10:43:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: heiko@sntech.de, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH V2] clockevents: rockchip: Add rockchip timer for
 rk3288
In-Reply-To: <1422178979-12382-1-git-send-email-daniel.lezcano@linaro.org>
Message-ID: <alpine.DEB.2.11.1501261041580.5526@nanos>
References: <1422178979-12382-1-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2015, Daniel Lezcano wrote:
> +static inline void rk_timer_set_mode(enum clock_event_mode mode,
> +				     struct clock_event_device *ce)
> +{
> +	switch (mode) {
> +	case CLOCK_EVT_MODE_PERIODIC:
> +		rk_timer_disable(ce);
> +		rk_timer_update_counter(rk_timer(ce)->freq / HZ - 1, ce);
> +		rk_timer_enable(ce, TIMER_MODE_FREE_RUNNING);

Missing break. You disable the timer again right away ...

> +	case CLOCK_EVT_MODE_ONESHOT:
> +	case CLOCK_EVT_MODE_RESUME:
> +		break;
> +	case CLOCK_EVT_MODE_UNUSED:
> +	case CLOCK_EVT_MODE_SHUTDOWN:
> +		rk_timer_disable(ce);
> +		break;
> +	}
> +}
> +
> +static irqreturn_t rk_timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *ce = dev_id;
> +
> +	rk_timer_interrupt_clear(ce);
> +
> +	if (ce->mode == CLOCK_EVT_MODE_ONESHOT) {
> +		rk_timer_disable(ce);
> +	}

No need for the braces here.

Thanks,

	tglx
