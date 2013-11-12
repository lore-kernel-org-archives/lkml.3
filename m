Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3KLPgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:36:09 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:36851 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab3KLPgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:36:07 -0500
Message-ID: <52824AE3.4050207@gmail.com>
Date: Tue, 12 Nov 2013 08:36:03 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf record: mmap output file - v5
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com> <1384267617-3446-5-git-send-email-dsahern@gmail.com> <20131112145707.GV5056@laptop.programming.kicks-ass.net> <20131112150751.GA19321@ghostprotocols.net> <20131112151944.GX5056@laptop.programming.kicks-ass.net>
In-Reply-To: <20131112151944.GX5056@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13, 8:19 AM, Peter Zijlstra wrote:
> On Tue, Nov 12, 2013 at 12:07:51PM -0300, Arnaldo Carvalho de Melo wrote:
>> Em Tue, Nov 12, 2013 at 03:57:07PM +0100, Peter Zijlstra escreveu:
>>> On Tue, Nov 12, 2013 at 07:46:56AM -0700, David Ahern wrote:
>>>> When recording raw_syscalls for the entire system, e.g.,
>>>>      perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
>>>>
>>>> you end up with a negative feedback loop as perf itself calls write() fairly
>>>> often. This patch handles the problem by mmap'ing the file in chunks of 64M at
>>>> a time and copies events from the event buffers to the file avoiding write
>>>> system calls.
>>>
>>> You know this completely fails the moment you trace faults, because
>>> every new access to one of those pages (to mark it dirty) will trigger a
>>> fault. And we'll take a bunch more faults -- one for each page -- than
>>> we ever did write() syscalls.
>>
>> So we should provide a neon lettered warning when doing that, no? :-)
>
> Dunno.. it _should_ all work. Try it and see what it does.. Once the
> events are bigger than a page things might get 'interesting' though.
>

one option here is not allow page faults and system wide system calls. 
system wide tracing needs mmap; page faults for a task can use write(). 
I left that option in case something like this came up.

David
