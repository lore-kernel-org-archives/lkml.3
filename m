Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab3LKVuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:50:00 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43857 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3LKVt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:49:57 -0500
Message-ID: <52A8DE00.6060007@gmail.com>
Date: Wed, 11 Dec 2013 14:49:52 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 13/71] perf tools: Add machine__get_thread_pid()
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>	<1386765443-26966-14-git-send-email-alexander.shishkin@linux.intel.com>	<52A8BCCE.9010300@gmail.com> <87fvpzulvl.fsf@tassilo.jf.intel.com>
In-Reply-To: <87fvpzulvl.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/13, 2:18 PM, Andi Kleen wrote:
> David Ahern <dsahern@gmail.com> writes:
>>
>> Are you looking up the current or next task? If the former why not use
>> sample->pid rather than parsing the sched_switch tracepoint?
>
> The itrace stream doesn't have a pid field, and it needs the exact
> time stamp of the switch. There may not actually be any samples
> before decoding.
>
> -Andi
>

What I meant is this:

perf record -e sched:sched_switch -a -- sleep 1 | perf script -f 
comm,tid,pid,event,trace


qemu-system-x86  8688/8692  sched:sched_switch: 
prev_comm=qemu-system-x86 prev_pid=8692 prev_prio=120 prev_state=S ==> 
next_comm=swapper/15 next_pid=0 next_prio=120

8688/8692 are the pid and tid of the running task. If you are monitoring 
sched_switch events and looking at running task -- the one getting 
scheduled out -- you don't need to parse the tracepoint. But, if you 
want to know next task then you do need to parse it. I was wondering 
which task is getting looked up.

David
