Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaHMIrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:47:53 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:62771 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaHMIrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:47:49 -0400
MIME-Version: 1.0
In-Reply-To: <CABuKBe+Q3tnN0s22EMY-dK_6FeN_xN9SmrsW3dPONR6QDJ+V_w@mail.gmail.com>
References: <1406824943-24052-1-git-send-email-matthias.bgg@gmail.com>
	<1406824943-24052-7-git-send-email-matthias.bgg@gmail.com>
	<CACRpkdbRhGE8tcKj+W_4F9-xmcm-fxcYuCmLOqX-ESC+3PAmyA@mail.gmail.com>
	<CABuKBe+Q3tnN0s22EMY-dK_6FeN_xN9SmrsW3dPONR6QDJ+V_w@mail.gmail.com>
Date: Wed, 13 Aug 2014 10:47:48 +0200
Message-ID: <CACRpkdZOB=9wQ3R3sfcBEiNXLVRtgob4iLZ9QWXyVrgjqyvGXQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] arm: mediatek: enable gpt6 on boot up to make arch
 timer working
From: Linus Walleij <linus.walleij@linaro.org>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        stefan@agner.ch, Maxime Ripard <maxime.ripard@free-electrons.com>,
        "Berg, Anders" <anders.berg@lsi.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 11:02 AM, Matthias Brugger
<matthias.bgg@gmail.com> wrote:
> 2014-08-11 9:15 GMT+02:00 Linus Walleij <linus.walleij@linaro.org>:
>> On Thu, Jul 31, 2014 at 6:42 PM, Matthias Brugger
>> <matthias.bgg@gmail.com> wrote:
>>
>>> We enable GTP6 which ungates the arch timer clock. Apart we write the
>>> frequency with which the timer is running in the CNTFREQ register.
>>> In the future this should be done in the bootloader.
>>>
>>> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>> (...)
>>
>>> +       if (of_machine_is_compatible("mediatek,mt6589")) {
>>> +               /* set cntfreq register which is not done in bootloader */
>>> +               asm volatile("mcr p15, 0, %0, c14, c0, 0" : : "r" (13000000));
>>
>> I guess this is for something like the ARM arch timer in
>> drivers/clocksource/arm_arch_timer.c
>>
>> Instead of doing this, use the DT property "clock-frequency" on
>> the ARM arch timer node, as that overrides the CP15 setting.
>>
>>> +
>>> +               /* turn on GPT6 which ungates arch timer clocks */
>>> +               gpt_base = ioremap(GPT6_CON_MT65xx, 0x04);
>>> +       }
>>> +
>>> +       /* enabel clock and set to free-run */
>>> +       if (gpt_base)
>>> +               writel(0x31, gpt_base);
>>
>> Why is this not done properly in the GPT driver (I guess
>> in drivers/clocksource/mtk_timer.c) instead of remapping
>> it and fiddling around in the machine?
>
> I didn't put it in the GPT driver, because that would mean, that you
> need to have the mtk_timer to be able to use the ARM arch timer.
> From my understanding this are two independent blocks in the SoC.
> Apart from that, as stated in the commit message, this patch is a
> workaround until we have a bootloader which does this for us.
> Therefore I thought the init_time function would be the better place to do this.

OK I get the point...

What about the ARM arch timer fixup then, will that also be
fixed in the boot loader eventually?

Yours,
Linus Walleij
