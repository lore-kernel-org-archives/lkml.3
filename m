Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbbAZJuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:50:44 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:49772 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbbAZJun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:50:43 -0500
Message-ID: <54C60DEF.7090709@linaro.org>
Date: Mon, 26 Jan 2015 10:50:39 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: heiko@sntech.de, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH V2] clockevents: rockchip: Add rockchip timer for rk3288
References: <1422178979-12382-1-git-send-email-daniel.lezcano@linaro.org> <alpine.DEB.2.11.1501261041580.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501261041580.5526@nanos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 10:43 AM, Thomas Gleixner wrote:
> On Sun, 25 Jan 2015, Daniel Lezcano wrote:
>> +static inline void rk_timer_set_mode(enum clock_event_mode mode,
>> +				     struct clock_event_device *ce)
>> +{
>> +	switch (mode) {
>> +	case CLOCK_EVT_MODE_PERIODIC:
>> +		rk_timer_disable(ce);
>> +		rk_timer_update_counter(rk_timer(ce)->freq / HZ - 1, ce);
>> +		rk_timer_enable(ce, TIMER_MODE_FREE_RUNNING);
>
> Missing break. You disable the timer again right away ...

Oops :)

Thanks for spotting this. I figured out why when I tested the timer, 
that worked: it ends up in any case in the noop ONESHOT/RESUME's break.

Fixed.

>> +	case CLOCK_EVT_MODE_ONESHOT:
>> +	case CLOCK_EVT_MODE_RESUME:
>> +		break;
>> +	case CLOCK_EVT_MODE_UNUSED:
>> +	case CLOCK_EVT_MODE_SHUTDOWN:
>> +		rk_timer_disable(ce);
>> +		break;
>> +	}
>> +}
>> +
>> +static irqreturn_t rk_timer_interrupt(int irq, void *dev_id)
>> +{
>> +	struct clock_event_device *ce = dev_id;
>> +
>> +	rk_timer_interrupt_clear(ce);
>> +
>> +	if (ce->mode == CLOCK_EVT_MODE_ONESHOT) {
>> +		rk_timer_disable(ce);
>> +	}
>
> No need for the braces here.

Thanks ! Fixed.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

