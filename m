Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbaGXOrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758976AbaGXOrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:47:07 -0400
Date: Thu, 24 Jul 2014 16:46:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, acme@kernel.org,
        namhyung.kim@lge.com, tzanussi@gmail.com
Subject: Re: [RFC] perf to ctf converter
Message-ID: <20140724144637.GE7652@krava.brq.redhat.com>
References: <20140603163640.GA16279@linutronix.de>
 <20140714141533.GD17761@krava.redhat.com>
 <20140721171151.GA12969@linutronix.de>
 <20140721183530.GA28673@krava.redhat.com>
 <53CE0B89.7030400@linutronix.de>
 <20140722112535.GA29750@krava.redhat.com>
 <53CE4BAF.2010906@linutronix.de>
 <53CE67B0.7020406@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CE67B0.7020406@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:31:28PM +0200, Sebastian Andrzej Siewior wrote:

SNIP

> 
> So the strings look good now. I also renamed "pid" to "common_pid" because
> 
> [06:37:09.885385418] (+0.017541187) sched:sched_wakeup: { cpu_id = 0 },
> { common_pid = 179, common_tid = 179, common_comm = ":179", comm = "ls",
> pid = 14068, prio = 120, success = 1, target_cpu = 5 }
> 
> that thing brings its own pid & comm.
> 
> And while looking at the data types and dropped that & LONG since it is
> not set for 64bit data types as I assumed. I do now consider ->size and
> the result is
> 
> [06:37:09.867838634] (+0.000253941) sched:sched_stat_runtime: { cpu_id =
> 0 }, { common_pid = 14068, common_tid = 14068, common_comm = "ls", comm
> = "ls", pid = 14068, runtime = 2020750, vruntime = 76395575003 }
> 
> that means vruntime is 64bit as it should and decimal might be nice.
> \o/
> 
> Sebastian

hi,
I made some changes over your branch:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/ctf_convert

following patches:
(needs to be prettyfied, but hopefuly works and ilustrate the point)
  perf tools: Iterate both common_fields and fields for tracepoit
  perf tools: Use sample_type for generic fields

we now add all fields available in the perf.data (via perf_event_attr:sample_type)
and then for tracepoints we add both common_types and types fields

I'm not sure we want to store made up data like symbol information,
which could be obtained from IP anyway - how does babeltrace or any
other CTF viewer do that?


---
However I'm still not convinced 100% this is the way we want
to go with this. What we do now is:
  - read/parse perf.data events and convert them into ctf events

What I/we do originally wanted to do was to use CTF to describe
perf event as is defined via perf interface, so we dont need to
parse data stream, but just store it.

This would be handy/needed for CTF record support, where we _want_
to store raw data from kernel and not parse it before that.

I'll recheck and get back with issues I found with this approach.

Meanwhile I think we can continue with what we have now,
I just wanted to share the other approach with you ;-)

thanks,
jirka
