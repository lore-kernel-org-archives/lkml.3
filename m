Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaLCTXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:23:31 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39001 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaLCTX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:23:29 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list\:ARM\/Rockchip SoC..." 
	<linux-rockchip@lists.infradead.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Tony Xie <xxx@rock-chips.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 0/4] This suspend patch is only support cut off the power of cpu and some external
References: <1417423940-1669-1-git-send-email-zyw@rock-chips.com>
	<7htx1f409k.fsf@deeprootsystems.com>
	<CAD=FV=V2go5BMFbiFKu73_aVz5ck949W-kJQ6WLkAQRPJbjPVA@mail.gmail.com>
	<CAD=FV=XuQk17CTNKJY++J+w9Ab9_OUX0ca0A99m7yKPAWSs2=w@mail.gmail.com>
	<7hmw763kql.fsf@deeprootsystems.com> <547F1639.3030102@rock-chips.com>
Date: Wed, 03 Dec 2014 11:23:26 -0800
In-Reply-To: <547F1639.3030102@rock-chips.com> (Chris Zhong's message of "Wed,
	03 Dec 2014 21:55:05 +0800")
Message-ID: <7hiohszgep.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Zhong <zyw@rock-chips.com> writes:

[...]

> I have test these patches on evb board base on next-20141128 with a
> defconfig[0], and with u-boot[1].
> As Doug said, we need below 3 patches for resume.
>
> 1.https://patchwork.kernel.org/patch/5051881/  - clocksource:
>    arch_timer: Allow the device tree to specify uninitialized timer
>    registers
>
> 2.https://patchwork.kernel.org/patch/5363671/  - clocksource:
>    arch_timer: Fix code to use physical timers when requested
>
> 3.https://patchwork.kernel.org/patch/5382141/  - ARM: dts: rk3288: add
>    arm,cpu-registers-not-fw-configured
>
>
> And it will auto wakeup, as Heiko said in v8.  

OK, with your series plus those 3 patches on top of next-20141128, I'm
now seeing it auto-wakeup, either with multi_v7_defconfig or Heiko's
rk3288_defconfig.

> But I have never notice before, since the u-boot never enable edp, and
> I use the coreboot with edp display.  Actually it is a bug in rk3288,
> the rk3288 have not 27Mhz clock source, but the edp initially set to
> this non-existent clock. At this time, edp is working on a unknown
> state, and it always bring a interrupt, this interrupt avoid system
> enter suspend. 

I see, good find!

> So if we want to enter suspend normally, the
> edp_24m_sel(bit 15) of CRU_CLKSEL28_CON(0xff7600d0) must be set to 1.

I didn't try your u-boot fix, but it sounds like there should be a kernel
fix for this.  Why doesn't the disabling of unused clocks put the EDP
into a safe/disabled state?

Kevin

