Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab3JAP5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:57:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43877 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3JAP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:57:48 -0400
Message-ID: <524AF0F8.3050008@wwwdotorg.org>
Date: Tue, 01 Oct 2013 09:57:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [RFC, PATCH] clocksource: provide timekeeping for efm32 SoCs
References: <1379324644-20934-1-git-send-email-u.kleine-koenig@pengutronix.de> <5242F434.7060702@linaro.org> <20131001080829.GJ2548@pengutronix.de>
In-Reply-To: <20131001080829.GJ2548@pengutronix.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 02:08 AM, Uwe Kleine-König wrote:
> On Wed, Sep 25, 2013 at 04:33:24PM +0200, Daniel Lezcano wrote:
>> On 09/16/2013 11:44 AM, Uwe Kleine-König wrote:
>>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>>> ---
>>> Hello,
>>>
>>> I'm not sure that the way I implemented if a given timer is used as
>>> clock_source or clock_event_device is robust. Does it need locking?
>>> The reason to create a timer device for each timer instead of a single
>>> device of all of them is that it makes it cleaner to specify irqs and
>>> clks which each timer has one of each respectively. I didn't find an
>>> example, but while looking I wondered if in zevio-timer.c a single timer
>>> can really support both clock_event and clocksource.
>>>
>>> I guess for inclusion I need to write a document describing the
>>> of-binding. I will include that in the next iteration.
>>
>> Right and a nice description of the timer would be valuable.
> Where is the location to put a device tree binding document for a
> clocksource/clock event device? I found
> 
> 	arm,armv7-timer-mem	| arm/arch_timer.txt
> 	fsl,timrot		| N/A
> 	nvidia,tegra20-rtc	| rtc/nvidia,tegra20-rtc.txt

The Tegra example isn't a good one here, since the Tegra HW block is
primarily an RTC (hence the location of the binding file), which also
happens to be able to act as the clocksource.

> Should I introduce a "clocksource" directory below
> Documentation/devicetree/bindings?

That seems reasonable for any HW block that is truly purely a
clocksource. However, you'd want to also check with all the other DT
bindings maintainers.
