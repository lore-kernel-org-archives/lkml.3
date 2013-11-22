Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3KVQg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:36:57 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44566 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab3KVQgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:36:55 -0500
Message-ID: <528F8807.7050803@ti.com>
Date: Fri, 22 Nov 2013 10:36:23 -0600
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <benoit.cousson@linaro.org>,
        <santosh.shilimkar@ti.com>, <jgchunter@gmail.com>, <rnayak@ti.com>,
        <balbi@ti.com>
Subject: Re: [PATCH 6/8] devicetree: doc: Document ti,timer-parent property
References: <1385085414-9034-1-git-send-email-joelf@ti.com> <1385085414-9034-7-git-send-email-joelf@ti.com> <20131122155838.GF10023@atomide.com>
In-Reply-To: <20131122155838.GF10023@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Thanks for your comments, few replies inline below..

On 11/22/2013 09:58 AM, Tony Lindgren wrote:
> * Joel Fernandes <joelf@ti.com> [131121 18:00]:
>> +Required properties for system timers (clockevents/clocksource):
>> +- ti,timer-parent:	System timer's parent mux clock needs to be setup.
>> +			This is currently hardcoded in code, for DT boot we
>> +			move this to DT.
>> +
> 
> This can be replaced with just clk_set_rate, or clk_set_parent if needed.
> Or by having a clocks = <&32k_clk> property in the dmtimer node in the
> .dts file.
> 

Sure, but clock-data is still not available to make this possible in mainline.
We also discussed earlier right that we don't want dependencies as much as
possible to get one chunk in and working at a time. I was thinking like for a
first-pass since there's a lot of unrelated code that doesn't have dependencies,
but needs this to work, we can introduce this property for now and drop it later
as a "cost of migration"?

>>  Optional properties:
>>  - ti,timer-alwon:	Indicates the timer is in an alway-on power domain.
> 
> Hmm this we may not need, this can probably be deciphered from the compatible
> flag already?

How? Compatible contains the same string, for example for OMAP4:

timer8 has:
                        compatible = "ti,omap4430-timer";
                        ti,timer-pwm;
                        ti,timer-dsp;

and timer9 has:
                        compatible = "ti,omap4430-timer";
                        ti,hwmods = "timer9";
                        ti,timer-pwm;


> 
> Then for the users of a specific dmtimer, they can select the right one using
> the interrupt-parent property:
> 
> timer1: timer@0x4800abcd {
> 	compatible = "ti,omap5430-timer";
> 	#interrupt-cells = <1>;		/* needs irqchip implemented for dmtimer */
> 	interrupt-controller;
> 	#clock-cells = <1>;		/* needs clocksource implemented for dmtimer */
> 	clock-output-names = "32k", "sys_ck";
> 	...
> };

In reference to my last thread reply, irqchip may not be available early in the
boot process (.init_time) for system timer usage?

thanks,

-Joel
