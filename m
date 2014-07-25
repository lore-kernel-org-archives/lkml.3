Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbaGYIha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:37:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:54936 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759584AbaGYIh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:37:27 -0400
Message-ID: <53D2173C.7090603@linutronix.de>
Date: Fri, 25 Jul 2014 10:37:16 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org, acme@kernel.org,
        namhyung.kim@lge.com, tzanussi@gmail.com
Subject: Re: [RFC] perf to ctf converter
References: <20140603163640.GA16279@linutronix.de> <20140714141533.GD17761@krava.redhat.com> <20140721171151.GA12969@linutronix.de> <20140721183530.GA28673@krava.redhat.com> <53CE0B89.7030400@linutronix.de> <20140722112535.GA29750@krava.redhat.com> <53CE4BAF.2010906@linutronix.de> <53CE67B0.7020406@linutronix.de> <20140724144637.GE7652@krava.brq.redhat.com>
In-Reply-To: <20140724144637.GE7652@krava.brq.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 04:46 PM, Jiri Olsa wrote:
> hi,

Hi,

> I made some changes over your branch:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   perf/ctf_convert
> 
> following patches:
> (needs to be prettyfied, but hopefuly works and ilustrate the point)
>   perf tools: Iterate both common_fields and fields for tracepoit
>   perf tools: Use sample_type for generic fields
> 
> we now add all fields available in the perf.data (via perf_event_attr:sample_type)
> and then for tracepoints we add both common_types and types fields
> 
> I'm not sure we want to store made up data like symbol information,
> which could be obtained from IP anyway - how does babeltrace or any
> other CTF viewer do that?

This is probably for Mathieu best to answer. I *think* that it records
pointers and does not resolve symbols if possible.

I assumed it to be a good thing to do because you don't get the symbols
anymore once the library/binary is upgraded unless you look for the old
files. But then the very same problem you have perf since it does not
record the symbol.
So we could drop the symbol resolution but then we would have to teach
babeltrace and friends to resolve it.

> ---
> However I'm still not convinced 100% this is the way we want
> to go with this. What we do now is:
>   - read/parse perf.data events and convert them into ctf events
> 
> What I/we do originally wanted to do was to use CTF to describe
> perf event as is defined via perf interface, so we dont need to
> parse data stream, but just store it.
> 
> This would be handy/needed for CTF record support, where we _want_
> to store raw data from kernel and not parse it before that.
> 
> I'll recheck and get back with issues I found with this approach.

Okay.

> Meanwhile I think we can continue with what we have now,

Good :)

> I just wanted to share the other approach with you ;-)
> 
> thanks,
> jirka

Sebastian
