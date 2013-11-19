Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3KSAYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 19:24:52 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42790 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3KSAYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 19:24:50 -0500
X-AuditID: 9c93017d-b7b24ae000002834-ce-528aafd0cf4d
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
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
	<20131118094036.GA26251@gmail.com>
Date: Tue, 19 Nov 2013 09:24:48 +0900
In-Reply-To: <20131118094036.GA26251@gmail.com> (Ingo Molnar's message of
	"Mon, 18 Nov 2013 10:40:36 +0100")
Message-ID: <877gc5utkf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Mon, 18 Nov 2013 10:40:36 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Fri, Nov 15, 2013 at 09:41:53AM -0700, David Ahern wrote:
>> > On 11/13/13, 4:34 AM, Peter Zijlstra wrote:
>> > >>>one option here is not allow page faults and system wide system calls.
>> > >>>system wide tracing needs mmap; page faults for a task can use write().
>> > >>>I left that option in case something like this came up.
>> > >>
>> > >>So maybe splice() sounds like the right long term solution after all? :-/
>> > >
>> > >Right until you put a tracepoint (kprobe) somewhere in whatever function
>> > >is used to transfer a single page into/from a splice pipe.
>> > >
>> > >You can always screw yourself over using this stuff, no exceptions.
>> > >
>> > 
>> > What now? Can we add the mmap path as an option?
>> 
>> I'd say an option is always a possibility, but someone please try 
>> what happens if you use stupid large events (dwarf stack copies) on 
>> PERF_COUNT_SW_PAGE_FAULTS (.period=1) while recording with mmap().
>> 
>> The other option is to simply disallow PERF_SAMPLE_STACK_USER for 
>> that event.
>> 
>> Personally I think 8k copies for every event are way stupid anyway, 
>> that's a metric ton of data at a huge cost.
>
> Well, with 1 khz sampling of a single threaded workload it's 8MB per 
> second - that's 80 MB for 10 seconds profiling - not the end of the 
> world.

We now use 4 khz sampling frequency by default, just FYI. :)

Thanks,
Namhyung
