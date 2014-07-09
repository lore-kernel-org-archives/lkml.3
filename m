Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbaGIOCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:02:52 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41959 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaGIOCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:02:48 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdb25foEcNroqLyZbX93FxqAZ7=2pGo6GPWP8YdrjUS8gg@mail.gmail.com>
References: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
	<CACRpkdYcoA-nifxojO5tZUy6dL6P2PTSGW0mVLUfqG20rOg-Nw@mail.gmail.com>
	<1404904380.16296.17.camel@iivanov-dev>
	<CACRpkdb25foEcNroqLyZbX93FxqAZ7=2pGo6GPWP8YdrjUS8gg@mail.gmail.com>
Date: Wed, 9 Jul 2014 07:02:48 -0700
Message-ID: <CAJAp7Og0Cr3oY=XpT4NzKUWykxkRTq1ZRDyamW6tgohfBs3dmg@mail.gmail.com>
Subject: Re: [PATCH 0/4] New Qualcomm PMIC pin controller drivers
From: Bjorn Andersson <bjorn@kryo.se>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 4:43 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Jul 9, 2014 at 1:13 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
>> On Wed, 2014-07-09 at 11:43 +0200, Linus Walleij wrote:
>>> On Mon, Jul 7, 2014 at 5:11 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
>>> Oh, I just spent some 45 minutes reviewing an 8xxx pinctrl driver from
>>> Björn Andersson
>>> that *seems* to be doing exactly the same thing.
>>>

Sorry for not getting comments out on Ivan's patches before you got here.

>>> Now I have two drivers from people outside Qualcomm :-)
>>>

:)

>>> Some of my review comments on Björn's driver (like using SI units with the pin
>>> config) are actually adressed in this patch set. The idea to split in subdrivers
>>> per-ASIC may be good? I don't really know.
>>>
>>> Can you two guys *PLEASE* join efforts and combine your drivers into one?
>>

The drivers can't be merged; the hardware is more or less identical,
but the register map is completely different.

However, the device tree bindings are a different thing; as the
properties used to describe the hardware doesn't relate to how we
communicate with it I think we should be able to (and therefor should)
use the same documentation for the two (rather 7) chips.

>> Not sure. Björn patches cover older PMIC chips, if not mistaken, mine
>> cover PMIC's used with APQ8074 and onward [1]. Main difference is
>> the bus which connects them to SoC, interrupts handling, runtime
>> pin type detection and register map.
>

Correct Ivan; we do however share the same issues related to how to do
interrupt handling, units for properties and how to split/reuse
between gpio and mpp. Also we have solved the pins vs groups vs
functions slightly different, that should all be aligned I think.

> Oh OK... then atleast there is something wrong with the naming of
> Björns patches as they are 8xxx and your chips are also named
> 8xxx ...
>

So, the pm8xxx series of drivers refer to pm8018, pm8038, pm8058,
pm8917 and pm8921 which are used in platforms in 8660, 8960 and 8064
(among others).
The driver that Ivan posted is for the pm8841 and pm8941; these are
using spmi instead of ssbi which gives a larger addressing space and
allows for a less dense register map, so all the plumbing in those
drivers will be different.
The suggestion is to call the "new gen stuff" qpnp instead, but to me
that's just a setup for hitting the same problem in a few years...

Nontheless, the hardware guys have painted us into a corner where
pm8xxx refer to a series of very similar pmics and pm8x41 is not one
of those.

> Anyway I will create a patch to move the current msm driver down
> to a folder named "qcom" and we can atleast collect these drivers
> in a single place since the chipsets are related, OK?
>

+1

> Then I guess even if the chips are totally unrelated it'd be interesting
> to have you two guys cross-review each other's drivers so the behaviour
> is consistent across qualcomm platforms.
>

I hope we can meet somewhere in between, so that we and other
developers will be able to recognize the common element and structures
later on. Again, sorry for not finding the time to preempt you on
that.

Regards,
Bjorn
