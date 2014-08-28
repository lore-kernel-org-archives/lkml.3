Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbaH1A4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 20:56:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39743 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbaH1A43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 20:56:29 -0400
Message-ID: <53FE7E3B.1010500@codeaurora.org>
Date: Wed, 27 Aug 2014 17:56:27 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Sonny Rao <sonnyrao@chromium.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
References: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org>	<CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com>	<CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com>	<53FE5B09.2020403@codeaurora.org> <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
In-Reply-To: <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/14 15:33, Olof Johansson wrote:
> On Wed, Aug 27, 2014 at 3:26 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> Is there any reason why the virtual counter can't be read? Maybe we're
>> the hyp and we need to make sure we don't use the virtual timer so that
>> the guest can use it, but that doesn't have any effect on the usage of
>> the virtual counter for the clocksource.
> There are several cases where virtual is unusable -- in particular it
> might not have been configured properly (i.e. the phys/virt offset is
> at a bad value).
>

Any specifics? It would be nice to say so in the commit text so that
others using such devices know they need this patch. I'm guessing the
firmware can't be fixed?

In this particular case is there actually a virtual interrupt but we've
explicitly removed it from the DT so that the driver can be forced into
using the physical counter? Or are we getting saved by the hyp check?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

