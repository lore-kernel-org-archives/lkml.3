Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbbAZJiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:38:46 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:63740 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbbAZJid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:38:33 -0500
Message-ID: <54C609E3.8020303@linaro.org>
Date: Mon, 26 Jan 2015 10:33:23 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kever Yang <kever.yang@rock-chips.com>, heiko@sntech.de
CC: devicetree@vger.kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH V2] clockevents: rockchip: Add rockchip timer for rk3288
References: <1422178979-12382-1-git-send-email-daniel.lezcano@linaro.org> <54C59782.80504@rock-chips.com>
In-Reply-To: <54C59782.80504@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 02:25 AM, Kever Yang wrote:
> Hi Daniel,

Hi Kever,

[ ... ]

>> +static inline int rk_timer_set_next_event(unsigned long cycles,
>> +                      struct clock_event_device *ce)
>> +{
>> +    rk_timer_disable(ce);
>> +    rk_timer_update_counter(cycles, ce);
>> +    rk_timer_enable(ce, TIMER_MODE_USER_DEFINED_COUNT);
>> +    return 0;
>> +}
>> +
>> +static inline void rk_timer_set_mode(enum clock_event_mode mode,
>> +                     struct clock_event_device *ce)
>> +{
>> +    switch (mode) {
>> +    case CLOCK_EVT_MODE_PERIODIC:
>> +        rk_timer_disable(ce);
>> +        rk_timer_update_counter(rk_timer(ce)->freq / HZ - 1, ce);
>> +        rk_timer_enable(ce, TIMER_MODE_FREE_RUNNING);
>> +    case CLOCK_EVT_MODE_ONESHOT:
> This driver seems init the timer as ONE SHOT mode, and we can
> set to PERIODIC by this code, but what if user set the timer
> as PERIODIC mode and then want to set back to ONESHOT mode?

Mmh, I think that will be followed by a call set_next_event, hence 
disabling the timer and set the right mode with the next event.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

