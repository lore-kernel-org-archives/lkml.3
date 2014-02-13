Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaBMNKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:10:53 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:36969 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaBMNKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:10:51 -0500
MIME-Version: 1.0
In-Reply-To: <20140213130228.GB2908@krava.brq.redhat.com>
References: <CABPqkBRzvfcdKGG4yY9q1PmtVL5Z=9H1RzHg8QDMN42a7=AF6A@mail.gmail.com>
	<20140211071401.GG27965@twins.programming.kicks-ass.net>
	<CABPqkBRn+AVUA-KTx-JQ28j1NhE4pDQe5vjb5NKGx0jrZq8g_Q@mail.gmail.com>
	<20140211105217.GS9987@twins.programming.kicks-ass.net>
	<CABPqkBROriDQa5-b-w45zV+2gS94oEW1c_bYwGmYAeYcqPoUog@mail.gmail.com>
	<20140211110242.GU9987@twins.programming.kicks-ass.net>
	<CABPqkBQhUCUOszQzBJZd_pwX-nLf6y=0X-+swPi0pE3ivRpVcg@mail.gmail.com>
	<CABPqkBSbBqOtvstKwQWD7jM8nn3XEdq0OXMjW8Z8oCF17uRYPw@mail.gmail.com>
	<20140211111421.GN27965@twins.programming.kicks-ass.net>
	<20140211115013.GE28757@ghostprotocols.net>
	<20140213130228.GB2908@krava.brq.redhat.com>
Date: Thu, 13 Feb 2014 14:10:49 +0100
Message-ID: <CABPqkBQAU7zfcKJiGXjaTiSsX6OJEA2OPH8N0+BzAoSE_t3ShA@mail.gmail.com>
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Joe Mario <jmario@redhat.com>,
        Richard Fowles <fowles@inreach.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 2:02 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Feb 11, 2014 at 08:50:13AM -0300, Arnaldo Carvalho de Melo wrote:
>> Em Tue, Feb 11, 2014 at 12:14:21PM +0100, Peter Zijlstra escreveu:
>> > On Tue, Feb 11, 2014 at 12:08:56PM +0100, Stephane Eranian wrote:
>> > > Assuming you can decode and get the info about the base registers used,
>> > > you'd have to do this for each arch with load/store sampling capabilities.
>> > > this is painful compared to getting the portable info from dwarf directly.
>>
>> > But its useful now, as compared to whenever GCC gets around to
>> > implementing more dwarves and that GCC getting used widely enough to
>> > actually rely on it.
>>
>> > All you need for the decode is a disassembler, and every arch should
>> > already have multiple of those. Should be easy to reuse one, right?
>>
>> Yeah, I never got around to actually try to implement this, but my
>> feeling was that all the bits and pieces were there already:
>>
>> 1) the precise IP for the instruction, that disassembled would tell
>> which registers were being operated on, or memory that we would "reverse
>> map" to a register
>>
>> 2) DWARF expression locations that allows us to go from registers to a
>> variable/parameter and thus to a type
>>
>> 3) PERF_SAMPLE_REGS_USER (from a quick look, why do we have "USER" in
>> it? Jiri?)
>
> well, it was meant for store user registers only
> to assists user DWARF unwind
>
But it does captures the user state regardless of the stack snapshotting.

> we can add PERF_SAMPLE_REGS_KERNEL
>
I have a patch series to do this and more. It will be ready next month
hopefully.

>>
>> 4) libunwind have register maps for various arches, so probably
>> something there could be reused here as well (Jiri?)
>
> not sure what you mean by 'something' here.. but yep,
> libunwind does have register maps for various arches
>
> jirka
