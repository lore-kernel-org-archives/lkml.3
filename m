Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbaAHVcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:32:21 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:42921 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331AbaAHVcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:32:16 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.10.1401081538350.1851@knanqh.ubzr>
References: <1389187991-26446-1-git-send-email-gautam.vivek@samsung.com>
	<20140108143529.GB14122@mudshark.cambridge.arm.com>
	<CAD=FV=WYe7Qk_XPs=FCeB7pbDz8AnG0txFcDyAQWWAU60vd-Sw@mail.gmail.com>
	<20140108192028.GM27432@n2100.arm.linux.org.uk>
	<CAD=FV=Ui8kec5vYA1jRT3EGNaUeWX-Ua5sUs+u3wdRz1oFnTzw@mail.gmail.com>
	<alpine.LFD.2.10.1401081538350.1851@knanqh.ubzr>
Date: Wed, 8 Jan 2014 13:32:15 -0800
X-Google-Sender-Auth: r5H8rD3vUCeXvsStLZ671ftNBOA
Message-ID: <CAD=FV=W_=NsEXwfnSw_VzwboDZHWU+AX09f0ECNX-XqYDF5Phg@mail.gmail.com>
Subject: Re: [PATCH] arm: Add Arm Erratum 773769 for Large data RAM latency.
From: Doug Anderson <dianders@chromium.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        David Garbett <David.Garbett@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas,

On Wed, Jan 8, 2014 at 12:58 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Wed, 8 Jan 2014, Doug Anderson wrote:
>
>> On Wed, Jan 8, 2014 at 11:20 AM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > We've been through these arguments many times, you're not the first to
>> > raise it, and we've decided upon the policy.  We want as _few_ work-
>> > arounds in the kernel as possible, because applying the work-arounds
>> > is very problematical with the mixture of secure and non-secure booting.
>>
>> OK, fair enough.  If we want no workaround here then we can drop this patch.
>>
>>
>> I'd guess that the way forward is:
>>
>> * Land kernel workaround locally in Chromium tree
>>
>> * I'll try to land FW change locally in at least one Chromium branch.
>> If we were to get a new RO build ever (seems unlikely at this point)
>> it would be fixed for upstream kernels.  If we were to get a new RW
>> build (seems unlikely, but at least less unlikely) it would be fixed
>> if someone landed a kernel patch to save/restore this register across
>> suspend/resume.
>>
>> * If Joe Upstream wants to run an upstream kernel on some type of
>> exynos5250 product (Samsung ARM Chromebook, HP Chromebook 11, Nexus 10
>> are the ones I know of) then he will deal with the small number of
>> crashes or figure out a solution.
>
> At some point you have to realize that what you're proposing is not
> viable when taking into account the bigger picture.  And your FW
> architecture is to blame.  If you were running Windows instead of Linux
> I bet you'd have found a way to fix things differently than asking
> Microsoft to add a special quirk in their code.  In the PC world you are
> required to perform a BIOS update instead.

Yup, I can believe that.

...I'm merely trying to report reality.  Firmware updates (even RW
ones) require an extra level of scrutiny / testing and a chunk of
in-house resources.  Those resources get allocated if there is no
other choice, but I can't force a lot of people to spend a lot of time
to approve a RW firmware update (actually approving >= 3 RW firmware
updates since there are at least three different 5250 variants) when
there is a simple and low risk kernel fix for it.  I could try, but
I'll get slapped down / laughed at.

If this were the Windows/x86 world and we had no choice the decision
would go a different way.  ...but we're not in the Windows/x86 world.


> So you really need to provision the ability to update at least a portion
> of the firmware that is not read-only.  That may be a third-stage
> bootloader or the like which purpose is only to install workarounds such
> as this before executing the kernel and which doesn't need to be updated
> with the kernel.  And in theory you should be able to do that on top of
> your current RO firmware.

The fact that we have too much code in RO is a known issue and people
are definitely working on that.  It has already bitten us.  It's
unlikely that someone will try retrofit something to work on existing
devices, though.

-Doug
