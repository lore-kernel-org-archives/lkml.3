Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaHTJ3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:29:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbaHTJ3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:29:19 -0400
Date: Wed, 20 Aug 2014 11:28:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Alexandre Montplaisir <alexmonthy@voxpopuli.im>
Cc: linux-kernel@vger.kernel.org,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: FW: [RFC 0/5] perf tools: Add perf data CTF conversion
Message-ID: <20140820092858.GA1203@krava.brq.redhat.com>
References: <53F38C74.4030300@voxpopuli.im>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F38C74.4030300@voxpopuli.im>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 01:42:12PM -0400, Alexandre Montplaisir wrote:
> Hi Jiri,
> 
> (sorry for breaking the thread, I didn't have the original email, but was
> forwarded it)

np, some other folks to the CC

> 
> I work on the Eclipse viewer (a.k.a. Trace Compass).
> 
> > so I've put perf converted CTF stream into the eclipse CTF trace viewer
> and got it displayed with the 'Generic CTF trace' type
> > The other type 'LTTng kernel trace' seems to set some rules for the CTF
> fields/format the trace has to obey. Is this described somewhere?
> 
> To identify an LTTng kernel trace, we check if the domain defined in the
> metadata is "kernel" [1]. I don't think we documented this anywhere though,
> we probably should!

ok, easy enough ;-) so I'm guessing this governs the expected
CTF layout for event/stream headers/contexts, right?

Also judging from the trace display, you have hardcoded specific
displays/actions for specific events? That's all connected/specific
under trace type?

> 
> Once we have some views or analysis specific to perf CTF traces, we could
> definitely add a separate trace type for those too.

I guess tracepoints and breakpoints should display something like
the standard kernel trace. As for HW events it's usual to display
profile infomation as the perf report does:
  https://perf.wiki.kernel.org/index.php/Tutorial#Sampling_with_perf_record

I tried to record/display lttng event perf:cpu:cycles, but got nothing
displayed in eclipse. Looks like this data provides only summary count
of the event for the workload?

thanks,
jirka
