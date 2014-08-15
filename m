Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaHOOhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:37:35 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58491 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaHOOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:37:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140815140741.GI19379@twins.programming.kicks-ass.net>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
	<20140814205143.GY6758@twins.programming.kicks-ass.net>
	<CAJ5Y-ebgJi8Ngxg1X+h7KMundGZPFhYC0hr0Sog6htj=czszgQ@mail.gmail.com>
	<20140815061917.GX19379@twins.programming.kicks-ass.net>
	<CAJ5Y-eaLxCG7dDao00pozXBL2dxPS7tf=xGfaz3O_xfRHtQZnA@mail.gmail.com>
	<20140815140741.GI19379@twins.programming.kicks-ass.net>
Date: Fri, 15 Aug 2014 10:37:32 -0400
Message-ID: <CAJ5Y-eZhAX47v4SjsW4T6PUaiMqC9wHcMDS8p+sL4_cReZpbyw@mail.gmail.com>
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Arjan van de Ven <arjan@linux.intel.com>, mingo@kernel.org,
        len.brown@intel.com, rjw@rjwysocki.net,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-acpi@vger.kernel.org,
        cpufreq@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 15 August 2014 10:07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Aug 15, 2014 at 09:08:50AM -0400, Ashwin Chaugule wrote:
>> If the OS only looks at Highest, Lowest, Delivered registers and only
>> writes to Desired, then we're not really any different than how we do
>> things today in the CPUFreq layer.
>
> The thing is; we're already struggling to make 'sense' of x86 as it
> stands today. And it looks like this CPPC stuff makes the behaviour even
> less certain.

I think its still better than the "p-state" thing we have going today,
where the algorithms are making their decisions based on the incorrect
assumption that the CPU got what it requested for. (among other things
listed earlier.) CPPC at least gives you a guarantee that the
delivered performance will be within a range you requested. It can
even force the platform to deliver a specific performance value if you
choose over a specific time window.

>
>> Or even in the case of
>> intel_pstate, if you map Desired to PERF_CTL and get value of
>> Delivered by using aperf/mperf ratios (as my experimental driver
>> does), then we can still maintain the existing system performance. It
>> seems like if an OS can make use of the additional information then it
>> should be net win for overall power savings and performance
>> enhancement. Also, using the CPPC descriptors, we should be able to
>> have one driver across X86 and ARM64. (possibly others too.)
>
> Yikes, so aaargh64 will go do creative power management too?

Nice use or aargh. ;) Strangely hadn't seen that before.

>
> And worse; it will go do ACPI? Welcome to the world of guaranteed BIOS
> fail :-(

ACPI or not, I think leads to a rather different kind of debate. :) If
all ARM implementations could include the CP15 equivalents of the CPPC
MSRs that Intel has, then we wouldn't need this CPPC table. But
that'll remain a pipe dream. So I'd prefer to think of CPPC as a
simple wrapper of registers descriptions which allows implementations
to choose how and where to get their CPPC information. However they
choose to implement the registers, I think theres a lot of potential
power savings and performance optimization on the table which can be
acquired through CPPC. Given the platforms some amount of freedom to
optimize things in a platform specific way helps them differentiate
themselves (a key thing with ARM esp.) and keeping the idea of CPU
performance abstract rather than tied to Frequency should help to keep
things unified in the OS, so we avoid the driver bloat that ARM
historically has had.

Cheers,
Ashwin
