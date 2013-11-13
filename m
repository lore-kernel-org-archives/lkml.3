Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309Ab3KMO30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:29:26 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40196 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3KMO3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:29:24 -0500
Message-ID: <52838CC2.2010301@gmail.com>
Date: Wed, 13 Nov 2013 07:29:22 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com> <1384267617-3446-5-git-send-email-dsahern@gmail.com> <20131112145707.GV5056@laptop.programming.kicks-ass.net> <20131112150751.GA19321@ghostprotocols.net> <20131112151944.GX5056@laptop.programming.kicks-ass.net> <52824AE3.4050207@gmail.com> <20131112211121.GC25913@gmail.com> <20131113113439.GI21461@twins.programming.kicks-ass.net> <20131113115021.GA15469@gmail.com>
In-Reply-To: <20131113115021.GA15469@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/13, 4:50 AM, Ingo Molnar wrote:
>>>> one option here is not allow page faults and system wide system
>>>> calls. system wide tracing needs mmap; page faults for a task can
>>>> use write(). I left that option in case something like this came up.
>>>
>>> So maybe splice() sounds like the right long term solution after all?
>>> :-/
>>
>> Right until you put a tracepoint (kprobe) somewhere in whatever function
>> is used to transfer a single page into/from a splice pipe.
>
> That ought to be a far less common occurance than tracing page faults
> though.
>
>> You can always screw yourself over using this stuff, no exceptions.
>
> Granted, as the many notrace markings demonstrate this stuff really wants
> to observe itself observing itself all the time! :)

perf can have options for output -- write(), mmap(), splice() -- and 
some logic of when not to use it:

1. don't use write for system wide tracing

2. don't use mmap for page fault tracing

3. don't use splice for .... (need a splice implementation)

and allow the user to override.

David
