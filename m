Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaHTTOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:14:20 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:24804 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbaHTTOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:14:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4GAIDvNVNFpamy/2dsb2JhbAA/GoMGO8NMgRcXdIIlAQEBAQIBOB4iAQULCw4KCRYPCQMCAQIBJxUJBg0BBwEBh20IDTbRVhMEjnoHhDgBA58biX6BaoNMIQ
X-IPAS-Result: Aq4GAIDvNVNFpamy/2dsb2JhbAA/GoMGO8NMgRcXdIIlAQEBAQIBOB4iAQULCw4KCRYPCQMCAQIBJxUJBg0BBwEBh20IDTbRVhMEjnoHhDgBA58biX6BaoNMIQ
X-IronPort-AV: E=Sophos;i="4.97,753,1389762000"; 
   d="scan'208";a="87304049"
Message-ID: <53F4F38C.4080407@voxpopuli.im>
Date: Wed, 20 Aug 2014 15:14:20 -0400
From: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: FW: [RFC 0/5] perf tools: Add perf data CTF conversion
References: <53F38C74.4030300@voxpopuli.im> <20140820092858.GA1203@krava.brq.redhat.com>
In-Reply-To: <20140820092858.GA1203@krava.brq.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 05:28 AM, Jiri Olsa wrote:
>
> ok, easy enough ;-) so I'm guessing this governs the expected
> CTF layout for event/stream headers/contexts, right?

Correct, if the domain is "kernel" we then assume that the rest of the 
trace contains the expected elements of a kernel trace.

Of course, one could craft a CTF trace to advertize itself as "kernel" 
or "ust", and not actually have the layout of that trace type, in which 
case it would fail parsing later on.

> Also judging from the trace display, you have hardcoded specific
> displays/actions for specific events? That's all connected/specific
> under trace type?

Yes the trace type is the main "provider" of functionality. I could go 
into more details, but we use Eclipse extension points to define which 
columns to put in the event table, which views are available, etc. for 
each supported trace type.

>> Once we have some views or analysis specific to perf CTF traces, we could
>> definitely add a separate trace type for those too.
> I guess tracepoints and breakpoints should display something like
> the standard kernel trace. As for HW events it's usual to display
> profile infomation as the perf report does:
>    https://perf.wiki.kernel.org/index.php/Tutorial#Sampling_with_perf_record

Interesting, I haven't tried the perf CTF output yet, but I could see it 
using the Statistics view (which by default just prints the % of events, 
per event type) to print the results of the different "perf reports", 
calculated from the CTF events. Eventually with pie charts!

> I tried to record/display lttng event perf:cpu:cycles, but got nothing
> displayed in eclipse. Looks like this data provides only summary count
> of the event for the workload?

Just to be sure I understand, you recorded an LTTng kernel trace, in 
which you enabled the "perf:cpu:cycles" context? Did this trace display 
anything in Babeltrace?
It should display the same in the Eclipse viewer, the value of the 
context will be visible in the "Contents" column in the the table (and 
in the Properties view), although for now we don't make any use of it.

 From what I understand, yes, the value of the different perf:* contexts 
represents the value of the perf counter at the moment the tracepoint 
was hit. So you cannot get perf data "in between" trace events when 
using this method.


Cheers,
Alexandre
