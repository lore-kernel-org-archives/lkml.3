Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab3HGIkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:40:20 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47652 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab3HGIkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:40:17 -0400
X-AuditID: 9c93017d-b7b45ae000000e34-22-520207f04f9b
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V9 04/14] perf tools: change machine__findnew_thread() to set thread pid
References: <1375719994-26482-1-git-send-email-adrian.hunter@intel.com>
	<1375719994-26482-5-git-send-email-adrian.hunter@intel.com>
	<87y58ex7k5.fsf@sejong.aot.lge.com> <5202068F.4000501@intel.com>
Date: Wed, 07 Aug 2013 17:40:15 +0900
In-Reply-To: <5202068F.4000501@intel.com> (Adrian Hunter's message of "Wed, 07
	Aug 2013 11:34:23 +0300")
Message-ID: <87li4dyjv4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Aug 2013 11:34:23 +0300, Adrian Hunter wrote:
> On 07/08/13 10:51, Namhyung Kim wrote:
>> On Mon,  5 Aug 2013 19:26:24 +0300, Adrian Hunter wrote:
>>> Add a new parameter for 'pid' to machine__findnew_thread().
>>> Change callers to pass 'pid' when it is known.
>>>
>> [SNIP]
>> 
>>> @@ -198,7 +198,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
>>>  
>>>  	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
>>>  
>>> -	thread = machine__findnew_thread(machine, event->ip.pid);
>>> +	thread = machine__findnew_thread(machine, event->ip.pid, event->ip.pid);
>> 
>> Maybe I'm missing something.  Why not use event->ip.tid here?
>
> That is covered here:
>
> 	http://marc.info/?l=linux-kernel&m=137513636309689&w=2

Oh, I missed the thread..

Btw, it'd be better if you keep David's (and possbily other's too)
Acked- or Reviewed-by tags in the changelog unless things changed
wildly.

[SNIP]
>> 
>> Hmm.. now I'm thinking that it's related to sharing map_groups between
>> threads within a process.  To do that, IMHO we need more sophisticated
>> handling rather than passing either pid or tid depending on contexts?
>
> Yes there is always more that could be done.

:)

Thanks,
Namhyung
