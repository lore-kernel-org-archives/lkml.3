Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbaAHVfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:35:30 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59561 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaAHVf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:35:28 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.10.1401081600370.1851@knanqh.ubzr>
References: <1389187991-26446-1-git-send-email-gautam.vivek@samsung.com>
	<20140108143529.GB14122@mudshark.cambridge.arm.com>
	<CAD=FV=WYe7Qk_XPs=FCeB7pbDz8AnG0txFcDyAQWWAU60vd-Sw@mail.gmail.com>
	<20140108192028.GM27432@n2100.arm.linux.org.uk>
	<CAD=FV=Ui8kec5vYA1jRT3EGNaUeWX-Ua5sUs+u3wdRz1oFnTzw@mail.gmail.com>
	<alpine.LFD.2.10.1401081600370.1851@knanqh.ubzr>
Date: Wed, 8 Jan 2014 13:35:27 -0800
X-Google-Sender-Auth: 57ek5CY5F_i0QYEhlZePZCxq1qI
Message-ID: <CAD=FV=XqoSGpQ_Yrjj4hvV_0FSMfQGcGEsKkL1Stnm9m5s2Xvw@mail.gmail.com>
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

On Wed, Jan 8, 2014 at 1:08 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Wed, 8 Jan 2014, Doug Anderson wrote:
>
>> Hi,
>>
>> On Wed, Jan 8, 2014 at 11:20 AM, Russell King - ARM Linux
>> > No, we're saying to put the work-around in the boot loader, not the kernel.
>>
>> Unfortunately the resume path of the firmware runs from Read Only
>> firmware code (yes, it sucks), so it's not totally trivial to fix. It
>> would be possible for someone to unscrew their write protect switch
>> and update their RO firmware, but that doesn't help the average user.
>
> [...]
>
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
> If Joe Upstream wants to run an upstream kernel, doesn't he have to
> unscrew his write protect switch first, at which point the RO firmware
> can be updated as well?

Actually, no.  You can move your device into dev mode and run any
kernel you want.  You'll get an annoying "you're in dev mode" screen
at every bootup, but otherwise it works just fine.

Going into dev mode requires some special keystrokes at bootup and a
wipe of your hard disk but no screwdrivers.


-Doug
