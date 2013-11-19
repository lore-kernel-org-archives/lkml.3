Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab3KSCCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:02:21 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64930 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3KSCCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:02:20 -0500
X-AuditID: 9c930197-b7caaae000001cef-24-528ac6aa27a5
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
	<1384267617-3446-5-git-send-email-dsahern@gmail.com>
	<20131112145707.GV5056@laptop.programming.kicks-ass.net>
	<20131112150751.GA19321@ghostprotocols.net>
	<20131112151944.GX5056@laptop.programming.kicks-ass.net>
	<52824AE3.4050207@gmail.com> <20131112211121.GC25913@gmail.com>
	<20131113113439.GI21461@twins.programming.kicks-ass.net>
	<52864ED1.1080607@gmail.com>
	<20131118090117.GE3866@twins.programming.kicks-ass.net>
	<20131118094036.GA26251@gmail.com> <877gc5utkf.fsf@sejong.aot.lge.com>
	<528AB229.6030603@gmail.com>
Date: Tue, 19 Nov 2013 11:02:18 +0900
In-Reply-To: <528AB229.6030603@gmail.com> (David Ahern's message of "Mon, 18
	Nov 2013 17:34:49 -0700")
Message-ID: <871u2dup1x.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013 17:34:49 -0700, David Ahern wrote:
> On 11/18/13, 5:24 PM, Namhyung Kim wrote:
>>>>> What now? Can we add the mmap path as an option?
>>>>
>>>> I'd say an option is always a possibility, but someone please try
>>>> what happens if you use stupid large events (dwarf stack copies) on
>>>> PERF_COUNT_SW_PAGE_FAULTS (.period=1) while recording with mmap().
>>>>
>>>> The other option is to simply disallow PERF_SAMPLE_STACK_USER for
>>>> that event.
>>>>
>>>> Personally I think 8k copies for every event are way stupid anyway,
>>>> that's a metric ton of data at a huge cost.
>>>
>>> Well, with 1 khz sampling of a single threaded workload it's 8MB per
>>> second - that's 80 MB for 10 seconds profiling - not the end of the
>>> world.
>>
>> We now use 4 khz sampling frequency by default, just FYI. :)
>
> I think Peter is asking about:
>     perf record -e faults -c 1 --call-graph dwarf,8192 -a -- sleep 1
>
> And as expected it is a massive feedback spiraling out of control.

How about adding an option to exclude the perf tools from recording for
system-wide (or cpu-wide) session?

This way, we can prevent the feedback loops for page-fault or syscall
events you mentioned IMHO.

Thanks,
Namhyung
