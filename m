Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbaIOUdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:33:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54813 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbaIOUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:33:09 -0400
Message-ID: <54174CFF.7050504@codeaurora.org>
Date: Mon, 15 Sep 2014 13:33:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Marc Zyngier <Marc.Zyngier@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Will Deacon <Will.Deacon@arm.com>, "olof@lixom.net" <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Mark Rutland <Mark.Rutland@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
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
Subject: Re: [PATCH v2] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
References: <1410452204-7277-1-git-send-email-dianders@chromium.org> <20140911164710.GW6158@arm.com> <5411D528.4050605@arm.com> <CAD=FV=XMmizxJFPj0FEhJ7Gk4ZcQaUJDxf_Qq5kGKSvxDFVmzg@mail.gmail.com> <5411DA67.2040402@arm.com> <CAD=FV=UQfo4J3P4wGjOhQZQ5KXKgYAdjPsi1ykKZxQw-FwJz8w@mail.gmail.com> <5411DF5D.8060906@arm.com> <5412DC48.7030708@codeaurora.org> <5412E3BB.9030800@arm.com> <54134291.3040700@codeaurora.org> <20140915111055.GD1577@arm.com>
In-Reply-To: <20140915111055.GD1577@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/14 04:10, Catalin Marinas wrote:
> On Fri, Sep 12, 2014 at 07:59:29PM +0100, Stephen Boyd wrote:
>> On 09/12/14 05:14, Marc Zyngier wrote:
>>> We surely can handle the UNDEF and do something there. We just can't do
>>> it the way Doug described it above.
>> I suggested doing that for something else a while ago and Will and Dave
>> we're not thrilled[1]. The suggestion back then was to use DT to
>> indicate what mode the kernel is running in.
>>
>> [1]
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-June/105321.html
> I think the context was slightly different. As I re-read the thread, it
> seems that the discussion was around whether to use some SMC interface
> or not based on whether the kernel is running secure or non-secure. The
> argument made by Will was to actually specify the type of the firmware
> SMC interface in the DT and use it in the kernel (and probably assume
> the kernel is running in secure mode if no smc interface is specified in
> the DT; you could have both though, running in secure mode and also
> having firmware).
>
> In this arch timer case, we need to work around a firmware bug (or
> feature as 32-bit ARM kernels never required CNTVOFF initialisation by
> firmware, no matter how small such firmware is). We don't expect a
> specific SMC call to initialise CNTVOFF, so we can't describe it in the
> DT.

Agreed, we can't described SMC calls that don't exist. From my
perspective it's just another part of the cpu boot sequence that needs
to be handled in the kernel, so describing the requirement via the
cpu-boot method seems appropriate. It seems like we're making it harder
than it should be by handling the undef when we could have slightly
different SMP boot code (and suspend/resume code) depending on the boot
method property.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

