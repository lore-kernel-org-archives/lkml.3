Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaE1IsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:48:15 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:48345 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaE1IsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:48:12 -0400
MIME-Version: 1.0
In-Reply-To: <1943407.eJZOu7V4pT@phil>
References: <CACRpkdZyLxMTSygRP6pD-mxghQ_D6tQ821tvn8GYw0Rnh9hZoQ@mail.gmail.com>
	<2480893.UEqfxe8meR@phil>
	<CACRpkdbaWYgku0_n5CqGU8DAFnn-5jEJ64Mfh9fixB4mRPnfwg@mail.gmail.com>
	<1943407.eJZOu7V4pT@phil>
Date: Wed, 28 May 2014 10:48:11 +0200
Message-ID: <CACRpkdYR9cZOnG2r3Kh027LNKgsDJqxL0J9Gryu+JHXacTNHbQ@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: Enable "power-source" to be extracted from DT files
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        James Hogan <james.hogan@imgtec.com>,
        Stephen Warren <swarren@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:36 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Mittwoch, 28. Mai 2014, 10:15:43 schrieb Linus Walleij:
>> On Tue, May 27, 2014 at 3:09 PM, Heiko Stübner <heiko@sntech.de> wrote:
>> > Am Dienstag, 27. Mai 2014, 09:27:36 schrieb Ivan T. Ivanov:
>> >> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>> >>
>> >> Add "power-source" property to generic options used for DT parsing files.
>> >> This  enables drivers, which use generic pin configurations, to get the
>> >> value passed to this property.
>> >
>> > I think the main problem here is, that pinconf-generic.h defines the
>> > power-
>> > source as having a "custom format". With DT as a hardware description,
>> > implementaton specific values do not work well - instead it should have a
>> > regular unit-value.
>> >
>> > For the power-source I think volts could work well - as this is the main
>> > use- case for pinctrl I know. The regulator-binding uses microvolts,
>> > maybe it would be good use a similar unit.
>>
>> (...)
>>
>> >         pcfg_1v8 {
>> >
>> >                 power-source = <1800000>;
>> >
>> >         };
>>
>> I don't think this is what it's meant for actually. In this case the thing
>> would be modeled as a regulator rather than some pin control option I
>> guess?
>>
>> I think it's more like a selector, such as found on old amplifiers,
>> input source A, B or C? So it's just some discrete number.
>
> as I said, you know this better than me ;-)
>
> I was thinking more of these io-voltages, where one can select between say 1.8
> and 3.3V for the pins.
>
> I have this somewhere on my todo list for the rockchips too.
>
> So essentially the pinctrl driver [as it is a pin-group specific setting]
> should just export regulators for these voltage settings, without touching the
> pinconfig itself, right?

Hm hm hm.

I am a bit in the blue actually.

I think we need to have a discussion with Mark Brown on how to
handle this.

We have previously had the case of MMC/SD level-shifters, where
a certain setting gives a certain level of signals out, and another setting
gives another level. Like two discrete levels.

So we modeled that as a regulator provider inside the pin control
driver eventually, see sh-pfc/pfc-sh73a0.c

But this is different: it is the power of the pin itself.

I can think of a "padring regulator" hooking in as part of the pin state
but have no clear idea on how to actually do that. We need some
coding I think.

Yours,
Linus Walleij
