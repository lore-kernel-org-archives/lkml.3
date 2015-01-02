Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbbABR0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:26:15 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46883 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbbABR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:26:14 -0500
Message-ID: <54A6D4B2.9070609@gmail.com>
Date: Fri, 02 Jan 2015 10:26:10 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Shaohua Li <shli@fb.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Kernel-team@fb.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
References: <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com> <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com> <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com> <20141219112350.GJ30905@twins.programming.kicks-ass.net> <CALCETrXRs5mXYq8OPH-WYqWPoD=35WccnHh7Bcm-YZMjW3ADcw@mail.gmail.com> <20141219170334.GM30905@twins.programming.kicks-ass.net> <20150102025953.GA1253265@devbig257.prn2.facebook.com> <54A6B9D5.5040804@gmail.com> <20150102170223.GA2381637@devbig257.prn2.facebook.com> <54A6D0B6.7090700@gmail.com> <20150102171738.GB2381637@devbig257.prn2.facebook.com>
In-Reply-To: <20150102171738.GB2381637@devbig257.prn2.facebook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/2/15 10:17 AM, Shaohua Li wrote:
> On Fri, Jan 02, 2015 at 10:09:10AM -0700, David Ahern wrote:
>> On 1/2/15 10:02 AM, Shaohua Li wrote:
>>> On Fri, Jan 02, 2015 at 08:31:33AM -0700, David Ahern wrote:
>>>> On 1/1/15 7:59 PM, Shaohua Li wrote:
>>>>> I'm wondering how we could use the perf to implament a clock_gettime.
>>>>> reading the perf fd or using ioctl is slow so reading the mmap
>>>>> ringbuffer is the only option. But as far as I know the ringbuffer has
>>>>> data only when an event is generated. Between two events, there is
>>>>> nothing we can read from the ringbuffer. Then how can application get
>>>>> time info in the interval?
>>>>
>>>> Are you wanting to read perf_clock from userspace?
>>>
>>> Yep, in some sort of form. Basically I want to read the time a task
>>> runs. Peter suggests we can read the activation time of a perf event.
>>> But I don't want to use any system call, as it's slow and likes
>>> clock_gettime.
>>
>> Since we cannot get the capability committed upstream a number of
>> folks are using this method:
>>
>>      https://github.com/dsahern/linux/blob/perf-full-monty/README.ahern
>>
>> ie., a KLM exports perf_clock and apps can use:
>>
>> #define CLOCK_PERF 14
>> if (clock_gettime(CLOCK_PERF, &ts) != 0) {
>> }
>>
>> No vdso acceleration, but works with an unmodified kernel.
>
> no, that's not what I want. as I said, we don't want any syscall (unless
> it's vdso based).

A number of clocks are vdso based (e.g., CLOCK_MONOTONIC). Those are not 
good enough?

David
