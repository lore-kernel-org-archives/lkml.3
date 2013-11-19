Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3KSAey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 19:34:54 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:65066 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3KSAew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 19:34:52 -0500
Message-ID: <528AB229.6030603@gmail.com>
Date: Mon, 18 Nov 2013 17:34:49 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com>	<1384267617-3446-5-git-send-email-dsahern@gmail.com>	<20131112145707.GV5056@laptop.programming.kicks-ass.net>	<20131112150751.GA19321@ghostprotocols.net>	<20131112151944.GX5056@laptop.programming.kicks-ass.net>	<52824AE3.4050207@gmail.com> <20131112211121.GC25913@gmail.com>	<20131113113439.GI21461@twins.programming.kicks-ass.net>	<52864ED1.1080607@gmail.com>	<20131118090117.GE3866@twins.programming.kicks-ass.net>	<20131118094036.GA26251@gmail.com> <877gc5utkf.fsf@sejong.aot.lge.com>
In-Reply-To: <877gc5utkf.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/13, 5:24 PM, Namhyung Kim wrote:
>>>> What now? Can we add the mmap path as an option?
>>>
>>> I'd say an option is always a possibility, but someone please try
>>> what happens if you use stupid large events (dwarf stack copies) on
>>> PERF_COUNT_SW_PAGE_FAULTS (.period=1) while recording with mmap().
>>>
>>> The other option is to simply disallow PERF_SAMPLE_STACK_USER for
>>> that event.
>>>
>>> Personally I think 8k copies for every event are way stupid anyway,
>>> that's a metric ton of data at a huge cost.
>>
>> Well, with 1 khz sampling of a single threaded workload it's 8MB per
>> second - that's 80 MB for 10 seconds profiling - not the end of the
>> world.
>
> We now use 4 khz sampling frequency by default, just FYI. :)

I think Peter is asking about:
     perf record -e faults -c 1 --call-graph dwarf,8192 -a -- sleep 1

And as expected it is a massive feedback spiraling out of control.

David
