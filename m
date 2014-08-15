Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaHOPs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:48:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:40291 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaHOPs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:48:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,870,1400050800"; 
   d="scan'208";a="559062891"
Message-ID: <53EE2BAA.1020603@linux.intel.com>
Date: Fri, 15 Aug 2014 08:47:54 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ashwin Chaugule <ashwin.chaugule@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        len.brown@intel.com, rjw@rjwysocki.net,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-acpi@vger.kernel.org,
        cpufreq@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>	<20140814205143.GY6758@twins.programming.kicks-ass.net>	<CAJ5Y-ebgJi8Ngxg1X+h7KMundGZPFhYC0hr0Sog6htj=czszgQ@mail.gmail.com>	<20140815061917.GX19379@twins.programming.kicks-ass.net>	<CAJ5Y-eaLxCG7dDao00pozXBL2dxPS7tf=xGfaz3O_xfRHtQZnA@mail.gmail.com>	<53EE0E5B.3050004@linux.intel.com>	<53EE10CB.7040001@linux.intel.com> <CAJ5Y-eZiRyGroems7J2oH05ybbbivM-okm3gFz7Mkuu8ceeCDQ@mail.gmail.com>
In-Reply-To: <CAJ5Y-eZiRyGroems7J2oH05ybbbivM-okm3gFz7Mkuu8ceeCDQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2014 7:24 AM, Ashwin Chaugule wrote:
>>>
>>> we've found that so far that there are two reasonable options
>>> 1) Let the OS device (old style)
>>> 2) Let the hardware decide (new style)
>>>
>>> 2) is there in practice today in the turbo range (which is increasingly
>>> the whole thing)
>>> and the hardware can make decisions about power budgetting on a timescale
>>> the OS
>>> can never even dream of, so once you give control the the hardware (with
>>> CPPC or native)
>>> it's normally better to just get out of the way as OS.
>>>
>>
>
> Interesting. This sounds like X86 plans to use the Autonomous bits
> that got added to the CPPC spec. (v5.1)?

if and when x86/Intel implement that, we will certainly evaluate it to see
how it behaves... but based on todays use of the hw control of the actual
p-state... I would expect that evaluation to pass.


note that on todays multi-core x96 systems, in practice you operate mostly
in the turbo range (I am ignoring mostly-idle workloads since there the
p-state isn't nearly as relevant anyway); all it takes for one of the cores to request
a turbo-range state, and the whole chip operates in turbo mode.. and in turbo mode
the hardware already picks the frequency/voltage.

with the current (and more so, past) Linux behavior, even at moderate loads you end up
there; the more cores you have the more true that becomes.



> I agree that the platform can
> make decisions on a much finer timescale. But even in the
> non-Autonomous mode, by providing the bounds around a Desired Value,
> the OS can get out of the way knowing that the platform would deliver
> something in the range it requested. If the OS can provide bounds, it
> seems to me that the platform can make more optimum decisions, rather
> than trying to guess whats running (or not).

I highly question that the OS can provide intelligent bounds.

When are you going to request an upper bound that is lower than maximum?
(don't say thermals, there are other mechanisms for controlling thermals
that work much better than direct P state control). Are you still going to do that
even if sometimes lower frequencies end up costing more battery?
(race-to-halt and all that)


I can see cases where you bump the minimum for QoS reasons, but even there I would
dare to say that at best the OS will be doing wild-ass guesses.


