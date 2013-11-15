Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab3KOQmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:42:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51545 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3KOQl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:41:56 -0500
Message-ID: <52864ED1.1080607@gmail.com>
Date: Fri, 15 Nov 2013 09:41:53 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com> <1384267617-3446-5-git-send-email-dsahern@gmail.com> <20131112145707.GV5056@laptop.programming.kicks-ass.net> <20131112150751.GA19321@ghostprotocols.net> <20131112151944.GX5056@laptop.programming.kicks-ass.net> <52824AE3.4050207@gmail.com> <20131112211121.GC25913@gmail.com> <20131113113439.GI21461@twins.programming.kicks-ass.net>
In-Reply-To: <20131113113439.GI21461@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/13, 4:34 AM, Peter Zijlstra wrote:
>>> one option here is not allow page faults and system wide system calls.
>>> system wide tracing needs mmap; page faults for a task can use write().
>>> I left that option in case something like this came up.
>>
>> So maybe splice() sounds like the right long term solution after all? :-/
>
> Right until you put a tracepoint (kprobe) somewhere in whatever function
> is used to transfer a single page into/from a splice pipe.
>
> You can always screw yourself over using this stuff, no exceptions.
>

What now? Can we add the mmap path as an option? Leave write by default 
and users can select mmap if they want? e.g., have out_size default to 0 
and 'perf trace record' can set --out-pages to 64M. It bypasses all 
system calls at the expense of more page faults.

David
