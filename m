Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841Ab3HHJyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:54:51 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:37682 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934079Ab3HHJyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:54:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130808092615.GF14648@e106331-lin.cambridge.arm.com>
References: <1375812017-6287-1-git-send-email-jwerner@chromium.org>
	<20130807163045.GK28558@e106331-lin.cambridge.arm.com>
	<CAODwPW9DmVdzHbHN0NUK0fYUNw0tj2ktyh-20no30r14_JayFQ@mail.gmail.com>
	<20130808092615.GF14648@e106331-lin.cambridge.arm.com>
Date: Thu, 8 Aug 2013 15:24:47 +0530
Message-ID: <CAFp+6iF6HoNsgyzM97H94Tbcqa599uE9z9XYVOxMivq1W6pnDw@mail.gmail.com>
Subject: Re: [PATCH 1/3 v5] usb: phy-samsung-usb: Simplify PMU register handling
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Julius Werner <jwerner@chromium.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 2:56 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Aug 07, 2013 at 06:06:05PM +0100, Julius Werner wrote:
>> > This breaks compatibility, both for an old kernel and a new dt and a new
>> > kernel with an old dt. Is anyone using these bindings?
>>
>> They only affect Samsung SoCs and have only been upstream for half a
>> year, so I doubt it's heavily used.
>
> I'm not sure everyone will be happy with that line.
>
>>
>> > Why are we describing fewer registers now? Are they described elsewhere?
>> >
>> > The dt should describe the device, not only the portion of it Linux
>> > wants to use right now.
>>
>> This only ever described a small section of the huge set of PMU
>> registers anyway. Before it described up to three registers
>> controlling different PHYs (using hardcoded offsets in the code to
>> later find the right one)... with my patch every PHY's DT entry only
>> describes the one register concerning itself, which makes more sense
>> in my opinion. It will also prevent the register descriptions in
>> different DT entries from overlapping.
>>
>
> I'm not sure I understand. The old documentation referred to the
> USBDEVICE_PHY_CONTROL and USBHOST_PHY_CONTROL registers for a phy, and
> your new version only refers to (usb device) PHY_CONTROL. Regardless of
> multiple phys, you're suggesting that we describe less of each phy.
> That seems like taking away usable information. Unless I've
> misunderstood?

Just giving some pointers here:

As also mentioned in the documentation for samsung-usbphy, SoCs prior
to exynos4x had only one PMU
register handling power to the PHYs (USB 2.0 phy to be specific).
Exynos4x SoCs also had USB 2.0 PHY only
but device and host PHYs' power was being handled by two registers
namely - USBDEVICE_PHY_CONTROL and
USBHOST_PHY_CONTROL.

Exynos5x series of SoCs now have USB 2.0 type PHY (both device and
host PHY are power-handled by only one register)
and USB 3.0 type PHY (having a separate PMU register to handle power
to PHY); so in a total of two registers but both
handling entirely separate PHYs.

So, samsung-usb2 phy driver should be interacting with only one PMU
register (with an exception for exynos4x)
and furthermore samsung-usb3phy driver interact with its separate PMU register.

Sylwester,
Please correct me if i am wrong somewhere.

>
> Ideally, we'd describe the whole set of registers and linkages to phys,
> even if Linux doesn't ahppen to use that information right now.
>
> Thanks,
> Mark.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek
