Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaHUPjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:39:47 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:56632 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaHUPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:39:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140821062420.GA4486@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
	<1408381749-14156-2-git-send-email-dianders@chromium.org>
	<20140819071011.GC12859@ulmo>
	<CAD=FV=Xr4ywGT_pPK=r6f6tfVpwbduUY7D5LK61HVtc8=JmkaA@mail.gmail.com>
	<20140820060759.GD13793@ulmo>
	<CAD=FV=Uqm43x0N=eOCQkY_MXviiD2WMw55pOZmC=WVRbD2+veg@mail.gmail.com>
	<20140820153801.GB3427@ulmo>
	<CAD=FV=Xf4Hm5tCaaW3QG-ZSQGovh6RKH=1Og1K-yxj+jKyGsmA@mail.gmail.com>
	<20140821062420.GA4486@ulmo>
Date: Thu, 21 Aug 2014 08:39:43 -0700
X-Google-Sender-Auth: kh2RL9qhjqfhV4F45PsCj0-TYOQ
Message-ID: <CAD=FV=WdJhGD=oSKGgAmHNgPmEfmp4rXtCxsjEdaijVK=dW=sA@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: rockchip: rk3288: Switch to use the proper PWM IP
From: Doug Anderson <dianders@chromium.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Olof Johansson <olof@lixom.net>,
        Eddie Cai <eddie.cai@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thierry and Heiko

On Wed, Aug 20, 2014 at 11:24 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Wed, Aug 20, 2014 at 08:55:09AM -0700, Doug Anderson wrote:
>> On Wed, Aug 20, 2014 at 8:38 AM, Thierry Reding <thierry.reding@gmail.com> wrote:
> [...]
>> > Looking at the register offsets in the device tree that seems likely. At
>> > least PWMs 0 and 1 as well as 2 and 3 seem like they could be in the
>> > same IP block. Their placement in the register map is somewhat strange:
>> >
>> >         pwm0: pwm@20030000 {
>> >                 ...
>> >                 reg = <0x20030000 0x10>;
>> >                 ...
>> >                 clocks = <&cru PCLK_PWM01>;
>> >                 ...
>> >         };
>> >
>> >         pwm1: pwm@20030010 {
>> >                 ...
>> >                 reg = <0x20030010 0x10>;
>> >                 ...
>> >                 clocks = <&cru PCLK_PWM01>;
>> >                 ...
>> >         };
>> >
>> >         ...
>> >
>> >         pwm2: pwm@20050020 {
>> >                 ...
>> >                 reg = <0x20050020 0x10>;
>> >                 ...
>> >                 clocks = <&cru PCLK_PWM23>;
>> >                 ...
>> >         };
>> >
>> >         pwm3: pwm@20050030 {
>> >                 ...
>> >                 reg = <0x20050030 0x10>;
>> >                 ...
>> >                 clocks = <&cru PCLK_PWM23>;
>> >                 ...
>> >         };
>>
>> Ah, you're looking at "rk3xxx.dtsi".  That doesn't apply to rk3288
>> (the downsides of trying to guess ahead of time what SoC vendors will
>> name new models).
>>
>> In rk3288 they have the same clocks.  See patch #3 in this series.
>>
>>
>> > The clocks would also indicate that there are actually two blocks. I
>> > seem to remember a discussion about whether to handle them as a single
>> > block or two/four, but I can't seem to find a reference to it. Maybe I'm
>> > confusing it with another driver.
>>
>> At this point it seems like the choice has already been made to handle
>> them as separate PWMs.  I can change this choice if you want...
>
> Well, looking at patch 3/4 this really does seem to be one single block
> providing four PWM channels, so the right thing to do would be to
> represent it in one device tree node. But I'll leave it up to Heiko to
> decide how he wants to handle this.
>
> One downside of describing it as one device is that it would make the
> pinmux handling slightly more difficult, since presumably you'd only
> want to apply the pinmux settings when a channel is actually being used.
> Currently the pinmux doesn't apply as long as the device remains
> disabled in device tree (though enabling it doesn't necessarily mean
> that it's being used).
>
> Like I said, it's up to Heiko to decide whether it's worth making this
> change (and it'd make sense to apply it to existing DTS files
> retroactively) or better to keep what we have.

Please let me know if you'd like me to spin.  Otherwise I'll assume
this is OK as is.

-Doug
