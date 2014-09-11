Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaIKROP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:14:15 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:38562 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaIKROM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140911170716.GA6158@arm.com>
References: <1410452204-7277-1-git-send-email-dianders@chromium.org>
	<20140911164710.GW6158@arm.com>
	<CAD=FV=WECbZ4L=-C+F9K6kfiPUi7ar3a4a7Upq2TqDYYPGoOrA@mail.gmail.com>
	<20140911170716.GA6158@arm.com>
Date: Thu, 11 Sep 2014 10:14:11 -0700
X-Google-Sender-Auth: zQDme7oXMZZ8Gw67qP7HuaJ4-bk
Message-ID: <CAD=FV=WsSgFFNj_2P0Ufi-WDYxywf8OrDh10y44XRLuNYOnyGA@mail.gmail.com>
Subject: Re: [PATCH v2] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
From: Doug Anderson <dianders@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "olof@lixom.net" <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On Thu, Sep 11, 2014 at 10:07 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Sep 11, 2014 at 05:59:53PM +0100, Doug Anderson wrote:
>> On Thu, Sep 11, 2014 at 9:47 AM, Will Deacon <will.deacon@arm.com> wrote:
>> > I'd say `Only supported for ARM' to better match what we've done. Probably
>> > also worth mentioning that this relies on the hypervisor/firmware having set
>> > CNTHCTL.PL1PCEN and CNTHCTL.EL1PCTEN (but assumedly made a mess of CNTVOFF
>> > ;) if you want to boot on the non-secure side (e.g. as a guest).
>>
>> Note that the reset value of CNTHCTL.PL1PCEN and CNTHCTL.PL1PCTEN are
>> both 1 in my version of the ARM ARM.  On the other hand CNTVOFF is
>> documented to have an UNKNOWN reset value.  If only ARM had guaranteed
>> that CNTVOFF started out as 0 (which seems like it would have been
>> sensible) we wouldn't be in this mess.  :-/
>
> I'm afraid we went the opposite way -- in ARMv8 there are a tiny handful
> of EL3 registers that are well-defined out of reset, then the rest of the
> system is UNKNOWN. The hardware guys prefer that and it can also be useful
> for very low-level debugging (system crashes, do a reset, read out the
> state).

Well, I guess if that's the way it is then software will have to deal
with it.  It sure seems like having things default to some state (even
if it's zero) at reset is really nice.  Otherwise you get things where
one 1 of every 10 times you boot the system it behaves differently and
that's hard to track down.  ...of course, then it maybe forces you to
think about really initting all bits in software and that's not
terrible.


-Doug
