Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaHUUDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:03:01 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:48710 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbaHUUDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:03:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4GAIDvNVNFpamy/2dsb2JhbABZgwbAeYMOgRcXdIIlAQEBAQIBOB4iAQULCw4KCQ8HBQoJAwIBAgEnFQkGDQEHAQGHbQizRJ5VF451BQcYhCABA58biX6BaoNMIQ
X-IPAS-Result: Aq4GAIDvNVNFpamy/2dsb2JhbABZgwbAeYMOgRcXdIIlAQEBAQIBOB4iAQULCw4KCQ8HBQoJAwIBAgEnFQkGDQEHAQGHbQizRJ5VF451BQcYhCABA58biX6BaoNMIQ
X-IronPort-AV: E=Sophos;i="4.97,753,1389762000"; 
   d="scan'208";a="87404751"
Message-ID: <53F65075.9050503@voxpopuli.im>
Date: Thu, 21 Aug 2014 16:03:01 -0400
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
References: <53F38C74.4030300@voxpopuli.im> <20140820092858.GA1203@krava.brq.redhat.com> <53F4F38C.4080407@voxpopuli.im> <20140821165841.GA32088@krava.brq.redhat.com>
In-Reply-To: <20140821165841.GA32088@krava.brq.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/21/2014 12:58 PM, Jiri Olsa wrote:
> hum, I've got nothing from babeltrace:
>
> [jolsa@krava ~]$ su
> Password:
> [root@krava jolsa]# lttng create perf
> Spawning a session daemon
> Session perf created.
> Traces will be written in /root/lttng-traces/perf-20140821-184956
> [root@krava jolsa]# lttng add-context -k -t prio -t perf:cpu:cycles

Oh I see the problem, you don't have any events enabled! In LTTng terms, 
a "context" is a piece of information that gets attached to every event. 
But if you don't have any event at all, you're not gonna see much 
context information. ;)

Try adding a
# lttng enable-event -a -k
before starting the session. This should give you some output in the 
viewers.


Cheers,
Alexandre


> kernel context prio added to all channels
> kernel context perf:cpu:cycles added to all channels
> [root@krava jolsa]# lttng start
> Tracing started for session perf
> [root@krava jolsa]# lttng stop
> Waiting for data availability.
> Tracing stopped for session perf
> [root@krava jolsa]# lttng destroy
> Session perf destroyed
> [root@krava jolsa]# babeltrace ~/lttng-traces/perf-20140821-184956/
> [root@krava jolsa]# babeltrace ~/lttng-traces/perf-20140821-184956/kernel/
> [root@krava jolsa]#
>
> and empty view in eclipse
>
> thanks,
> jirka

