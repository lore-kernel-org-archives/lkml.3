Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaHOOYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:24:36 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:47039 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaHOOYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:24:33 -0400
MIME-Version: 1.0
In-Reply-To: <53EE10CB.7040001@linux.intel.com>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
	<20140814205143.GY6758@twins.programming.kicks-ass.net>
	<CAJ5Y-ebgJi8Ngxg1X+h7KMundGZPFhYC0hr0Sog6htj=czszgQ@mail.gmail.com>
	<20140815061917.GX19379@twins.programming.kicks-ass.net>
	<CAJ5Y-eaLxCG7dDao00pozXBL2dxPS7tf=xGfaz3O_xfRHtQZnA@mail.gmail.com>
	<53EE0E5B.3050004@linux.intel.com>
	<53EE10CB.7040001@linux.intel.com>
Date: Fri, 15 Aug 2014 10:24:32 -0400
Message-ID: <CAJ5Y-eZiRyGroems7J2oH05ybbbivM-okm3gFz7Mkuu8ceeCDQ@mail.gmail.com>
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        len.brown@intel.com, rjw@rjwysocki.net,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-acpi@vger.kernel.org,
        cpufreq@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On 15 August 2014 09:53, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 8/15/2014 6:42 AM, Arjan van de Ven wrote:
>> On 8/15/2014 6:08 AM, Ashwin Chaugule wrote:
>>> (b) we come up with ways to provide the bounds around a Desired value
>>> using the information from the platform. (long term)
>>>
>>> I briefly looked at the x86 HWP (Hardware Performance States) in the
>>> s/w manual again. Its essentially an implementation of CPPC. It seems
>>> like X86 has implemented most if not all these registers as MSRs. I'm
>>> really interested in knowing if anyone there is/has been working on
>>> using them and what they found.
>>
>>
>> we've found that so far that there are two reasonable options
>> 1) Let the OS device (old style)
>> 2) Let the hardware decide (new style)
>>
>> 2) is there in practice today in the turbo range (which is increasingly
>> the whole thing)
>> and the hardware can make decisions about power budgetting on a timescale
>> the OS
>> can never even dream of, so once you give control the the hardware (with
>> CPPC or native)
>> it's normally better to just get out of the way as OS.
>>
>

Interesting. This sounds like X86 plans to use the Autonomous bits
that got added to the CPPC spec. (v5.1)? I agree that the platform can
make decisions on a much finer timescale. But even in the
non-Autonomous mode, by providing the bounds around a Desired Value,
the OS can get out of the way knowing that the platform would deliver
something in the range it requested. If the OS can provide bounds, it
seems to me that the platform can make more optimum decisions, rather
than trying to guess whats running (or not).

> I should clarify this; with increasing number of cores, you end up with much
> more dynamic maximums
> (e.g. turbo in Intel speak) and the hardware already controls this (yes the
> OS gives hints, but
> that's mostly a lot of OS work for little value)
>

Going completely Autonomous (i.e. letting the platform decide whats
best w/o OS hints) may be possible only for some platforms. There will
be several ones which dont have that kind of logic built into the
hardware. In such cases getting OS hints would be the only option.

>
> in a single or even dual core situation you may have a different ballgame
> with a small turbo range, but even in phones
> octocores seem to be the norm nowadays ;-)
> (just finished reading the Samsung announcement)

Yea, its getting crazy out there.

Cheers,
Ashwin
