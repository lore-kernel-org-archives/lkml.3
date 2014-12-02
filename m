Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbaLBBSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 20:18:30 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:43296 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaLBBS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 20:18:28 -0500
X-Greylist: delayed 58920 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Dec 2014 20:18:27 EST
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: linux-arm-kernel@lists.infradead.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <256dda5333c4095d5782d698522d5720>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <547D134C.6090300@rock-chips.com>
Date: Tue, 02 Dec 2014 09:18:04 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Kevin Hilman <khilman@kernel.org>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Tony Xie <xxx@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 0/4] This suspend patch is only support cut off the
 power of cpu and some external
References: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>	<7htx1f409k.fsf@deeprootsystems.com> <CAD=FV=V2go5BMFbiFKu73_aVz5ck949W-kJQ6WLkAQRPJbjPVA@mail.gmail.com>
In-Reply-To: <CAD=FV=V2go5BMFbiFKu73_aVz5ck949W-kJQ6WLkAQRPJbjPVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/02/2014 06:08 AM, Doug Anderson wrote:
> Hi,
>
> On Mon, Dec 1, 2014 at 11:51 AM, Kevin Hilman <khilman@kernel.org> wrote:
>> Chris Zhong <zyw@rock-chips.com> writes:
>>
>>> devices, since we still lack power_domain driver, so the other power rail
>>> of rk3288 need keep power on.
>>> I have tested it on rk3288-evb board, atop next-20141112. goto suspend by type
>>> "echo mem > /sys/power/state", vdd_cpu is about 0mv by measuring, so it can be
>>> determined in sleep mode, then press power button to wakeup it.
>> I tested this on top of today's linux-next (next-20141201) and it
>> suspends, but doesn't wake up from any of the button presses.  What
>> wakeup sources are configured for the rk3288-evb-rk808?
> Just to close the loop (I talked with Kevin over IM about this, too):
>
> I have a huge description of how I tested this as part of my patch at
> <https://patchwork.kernel.org/patch/5414941/>.  Chris:  I think Kevin
> has asked you several times to include information like this in your
> cover letter.  Please, please, please can you try to remember to do
> this?

I wrote it to v8 cover letter, but I found that they are all landed on 
linux-next now, so I remove they from v9, v10.

Based on:
[v5,1/6] ARM: rockchip: convert to regmap and use pmu syscon if available
https://patchwork.kernel.org/patch/5086341/
[v5,2/6] ARM: rockchip: add option to access the pmu via a phandle in smp_operations
https://patchwork.kernel.org/patch/5086441/
[v5,3/6] ARM: dts: rockchip: add pmu references to cpus nodes
https://patchwork.kernel.org/patch/5086351/
[v5,4/6] ARM: rockchip: add basic smp support for rk3288
https://patchwork.kernel.org/patch/5086371/
[v5,5/6] ARM: dts: rockchip: add intmem node for rk3288 smp support
https://patchwork.kernel.org/patch/5086361/
[v5,6/6] ARM: dts: rockchip: add reset for CPU nodes
https://patchwork.kernel.org/patch/5086381/
[v3] usb: dwc2: add bus suspend/resume for dwc2
https://patchwork.kernel.org/patch/5266281/


But I missed this 3 patches, since I thought they just for fix timer 
disorder when I use coreboot.
Doug said they are related to SMP and related to suspend/resume.

1. https://patchwork.kernel.org/patch/5051881/ - clocksource:
    arch_timer: Allow the device tree to specify uninitialized timer
    registers

2. https://patchwork.kernel.org/patch/5363671/ - clocksource:
    arch_timer: Fix code to use physical timers when requested

3. https://patchwork.kernel.org/patch/5382141/ - ARM: dts: rk3288: add
    arm,cpu-registers-not-fw-configured


I'm not sure whether we need these 2 patches.

4. Revert (b77d439 ARM: dts: rockchip: temporarily disable smp on
    rk3288)

5. https://patchwork.kernel.org/patch/5325111/ - usb: dwc2: resume
    root hub when device detect with suspend state



>
> For those that don't want to click on my link, I'll include the
> relevant bits here:
>
> ---
>
> Total patches atop that version of Linux were:
>
> 1. https://patchwork.kernel.org/patch/5051881/ - clocksource:
>     arch_timer: Allow the device tree to specify uninitialized timer
>     registers
>
> 2. https://patchwork.kernel.org/patch/5363671/ - clocksource:
>     arch_timer: Fix code to use physical timers when requested
>
> 3. https://patchwork.kernel.org/patch/5382141/ - ARM: dts: rk3288: add
>     arm,cpu-registers-not-fw-configured
>
> 4. Revert (b77d439 ARM: dts: rockchip: temporarily disable smp on
>     rk3288)
>
> 5. https://patchwork.kernel.org/patch/5325111/ - usb: dwc2: resume
>     root hub when device detect with suspend state
>
> 6. https://patchwork.kernel.org/patch/5410611/ - ARM: rockchip: add
>     suspend and resume for RK3288
>
> 7. https://patchwork.kernel.org/patch/5410621/ - ARM: rockchip: Add
>     pmu-sram binding
>
> 8. https://patchwork.kernel.org/patch/5410631/ - ARM: dts: add RK3288
>     suspend support
>
> 9. https://patchwork.kernel.org/patch/5410641/ - ARM: dts: rockchip:
>     add suspend settings for rk3288-evb-rk808
>
> It looks like my pinctrl patches might be dropped due to cross
> dependency problems, so tomorrow's linux-next will probably also need
> (https://patchwork.kernel.org/patch/5344551/ - pinctrl: rockchip:
> Handle wakeup pins).
>
> I've also got a local hack to the Rockchip "pm.c" to replace the usage
> of "PMU_ARMINT_WAKEUP_EN" with 0x0e.  There seems to be some sort of
> ARM Interrupt waking us up all the time right when we go to sleep and
> the above will hack it so that only GPIOs + SDMMC Card Detect can wake
> us up.  Someone should track down what's going on there, but for now
> I've used the hack to prove that the basic code actually works.
>
>
>


