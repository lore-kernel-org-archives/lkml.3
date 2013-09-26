Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3IZIwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:52:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60570 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3IZIwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:52:32 -0400
Message-ID: <5243F5CD.6090709@linaro.org>
Date: Thu, 26 Sep 2013 10:52:29 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC, PATCH] clocksource: provide timekeeping for efm32 SoCs
References: <1379324644-20934-1-git-send-email-u.kleine-koenig@pengutronix.de> <5242F434.7060702@linaro.org> <20130925153207.GG16106@pengutronix.de> <524376A0.7020405@linaro.org> <20130926082059.GI16106@pengutronix.de>
In-Reply-To: <20130926082059.GI16106@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 10:20 AM, Uwe Kleine-König wrote:
> Hello Daniel,
>
> On Thu, Sep 26, 2013 at 01:49:52AM +0200, Daniel Lezcano wrote:
>> On 09/25/2013 05:32 PM, Uwe Kleine-König wrote:
>>>>> +static void __init efm32_timer_init(struct device_node *np)
>>>>> +{
>>>>> +	static int has_clocksource, has_clockevent;
>>>>> +	int ret;
>>>>> +
>>>>> +	if (!has_clocksource) {
>>>>> +		ret = efm32_clocksource_init(np);
>>>>> +		if (!ret) {
>>>>> +			has_clocksource = 1;
>>>>> +			return;
>>>>> +		}
>>>>> +	}
>>>>> +
>>>>> +	if (!has_clockevent) {
>>>>> +		ret = efm32_clockevent_init(np);
>>>>> +		if (!ret) {
>>>>> +			has_clockevent = 1;
>>>>> +			return;
>>>>> +		}
>>>>> +	}
>>>>> +}
>>>>
>>>> I don't get the purpose of this initialization, can you explain ?
>>> An efm32 SoC has four timer blocks. A single block can only be used for
>>> one of clocksource or clockevent device and having more than one
>>> clocksource or clockevent device doesn't make sense. So this routine
>>> asserts that the first timer is used as clocksource and the second as
>>> clockevent device. The others are unused.
>>
>> Shouldn't be up to the dt to give the timers you want ?
> The dt looks as follows:
>
>                  timer0: timer@40010000 {
>                          compatible = "efm32,timer";
>                          reg = <0x40010000 0x400>;
>                          interrupts = <2>;
>                          clocks = <&cmu clk_HFPERCLKTIMER0>;
>                  };
>
>                  timer1: timer@40010400 {
>                          compatible = "efm32,timer";
>                          reg = <0x40010400 0x400>;
>                          interrupts = <12>;
>                          clocks = <&cmu clk_HFPERCLKTIMER1>;
>                  };
>
>                  timer2: timer@40010800 {
>                          compatible = "efm32,timer";
>                          reg = <0x40010800 0x400>;
>                          interrupts = <13>;
>                          clocks = <&cmu clk_HFPERCLKTIMER2>;
>                  };
>
>                  timer3: timer@40010c00 {
>                          compatible = "efm32,timer";
>                          reg = <0x40010c00 0x400>;
>                          interrupts = <14>;
>                          clocks = <&cmu clk_HFPERCLKTIMER3>;
>                  };
>
> What is your suggestion now?
> Add a property that specifies if the block
> should be used as clocksource or clockevent_device? That isn't a
> hardware description and so shouldn't go into the device tree.

At this point, I just asked a question and did not make any suggestion.

> Provide two drivers that match on "efm32,timer", one for clocksource and
> another for clockevent_device? That wouldn't work, too, as the first
> driver to be loaded would grab all four timers and the second would get
> none.

Thanks, now I understand the purpose of this routine, it is very similar 
than:

http://www.spinics.net/lists/arm-kernel/msg273984.html

right ?



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

