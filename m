Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab3KOMpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:45:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:4870 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab3KOMpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:45:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="435794611"
Message-ID: <5286191C.1090601@intel.com>
Date: Fri, 15 Nov 2013 14:52:44 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 10/10] perf record: Add an option to force per-cpu mmaps
References: <1384460715-23198-1-git-send-email-acme@infradead.org> <1384460715-23198-11-git-send-email-acme@infradead.org> <20131115060643.GA9237@gmail.com> <5285FECE.7020802@intel.com> <20131115111032.GA18647@gmail.com> <52860529.50200@intel.com> <20131115115629.GB19004@gmail.com> <20131115120329.GH2965@twins.programming.kicks-ass.net>
In-Reply-To: <20131115120329.GH2965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/11/13 14:03, Peter Zijlstra wrote:
> On Fri, Nov 15, 2013 at 12:56:29PM +0100, Ingo Molnar wrote:
>> So, here's the current status quo, there's 4 basic types of profiling 
>> that 99% of the people are using, in order of popularity:
>>
>> 	perf record <cmd>
>> 	perf record -a sleep N
>> 	perf record -p <PID>
>> 	perf record -t <TID>
>>
>> The first two (which I'd guess comprise about 95% of real-world usage) 
>> have inheritance enabled.
>>
>> The last two (-p/-t) have inheritance disabled by default.
> 
> Yes, and I would expect it to be disabled for the TID option as you
> explicitly select a single threads.

So you want -t to imply -i ?

That means if you want inheritance you have to do

	-t <TID> --no-no-inherit

Or do you want another option --inherit

> 
> For the process wide thing it would make sense to enable inheritance by
> default though.
> 
> So the big trade-off is that for single threaded processes which do not
> fork you now have a single buffer, whereas with the inheritance option
> you'll end up with nr_cpus buffers by default.
> 
> I suppose for most normal people that's not really an issue; and I
> suppose all people with silly large machines already pay extra attention
> -- but at least make it explicit and very clear that this is so.
> 
> 
> 
> 

