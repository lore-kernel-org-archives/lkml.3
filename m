Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaH1RJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 13:09:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43236 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaH1RJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 13:09:36 -0400
Message-ID: <53FF624C.3090002@codeaurora.org>
Date: Thu, 28 Aug 2014 13:09:32 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clocksource: arch_timer: Fix code to use physical timers
 when requested
References: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org> <CAOesGMjK65Rc-K0fyFUUJLw6huLT82E-nqJwZO4PqhgopF96Ow@mail.gmail.com> <CAPz6YkWAPtuy4sAuAK9GtpDgfGsccxeS+pqqe_t_R818Jt01qA@mail.gmail.com> <53FE5B09.2020403@codeaurora.org> <CAOesGMhTivDzJFuxONggcJ6N5UvZopKa=+tv9PoPX593cpnm0A@mail.gmail.com> <53FE7E3B.1010500@codeaurora.org> <CAOesGMgXnsqttHwAxEW4a7-Rx-nmSwpJd_Dt1iCcFOvzDwbzdA@mail.gmail.com> <CAD=FV=VjN6Xam-nRRcxvOoN-gokU6DbGVjoPXN_fkTJssH1RWA@mail.gmail.com> <20140828093505.GC14650@leverpostej>
In-Reply-To: <20140828093505.GC14650@leverpostej>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 08/28/2014 05:35 AM, Mark Rutland wrote:
> On Thu, Aug 28, 2014 at 04:33:31AM +0100, Doug Anderson wrote:
>> Hi,
>>
>> On Wed, Aug 27, 2014 at 7:58 PM, Olof Johansson <olof@lixom.net> wrote:
>>> On Wed, Aug 27, 2014 at 5:56 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>>> On 08/27/14 15:33, Olof Johansson wrote:
>>>>> On Wed, Aug 27, 2014 at 3:26 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>>>>
>>>>>> Is there any reason why the virtual counter can't be read? Maybe we're
>>>>>> the hyp and we need to make sure we don't use the virtual timer so that
>>>>>> the guest can use it, but that doesn't have any effect on the usage of
>>>>>> the virtual counter for the clocksource.
>>>>>
>>>>> There are several cases where virtual is unusable -- in particular it
>>>>> might not have been configured properly (i.e. the phys/virt offset is
>>>>> at a bad value).
>>>>
>>>> Any specifics? It would be nice to say so in the commit text so that
>>>> others using such devices know they need this patch. I'm guessing the
>>>> firmware can't be fixed?
>>
>> Even if we could change things to use a virtual timer in some cases,
>> Sonny's patch still fixes a bug.  The code as written right now makes
>> pretenses about supporting the physical timer, but it doesn't work.
>> That should be fixed.
> 
> The code does support the physical timer. It does not support the
> physical counter (and makes no pretenses that it does).

I think if you could please explain the following code, that may help clear up
some of the confusion.

		if (arch_timer_use_virtual) {
			clk->irq = arch_timer_ppi[VIRT_PPI];
			clk->set_mode = arch_timer_set_mode_virt;
			clk->set_next_event = arch_timer_set_next_event_virt;
		} else {
			clk->irq = arch_timer_ppi[PHYS_SECURE_PPI];
			clk->set_mode = arch_timer_set_mode_phys;
			clk->set_next_event = arch_timer_set_next_event_phys;
		}

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/clocksource/arm_arch_timer.c#n272

Perhaps you mean to say the code does not support *non-secure access* to the
physical timer?

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
