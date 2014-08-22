Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbaHVQrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:47:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208AbaHVQrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:47:06 -0400
Date: Fri, 22 Aug 2014 18:46:44 +0200
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
Message-ID: <20140822164644.GC22315@krava.brq.redhat.com>
References: <53F38C74.4030300@voxpopuli.im>
 <20140820092858.GA1203@krava.brq.redhat.com>
 <53F4F38C.4080407@voxpopuli.im>
 <20140821165841.GA32088@krava.brq.redhat.com>
 <53F65075.9050503@voxpopuli.im>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F65075.9050503@voxpopuli.im>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 04:03:01PM -0400, Alexandre Montplaisir wrote:
> 
> On 08/21/2014 12:58 PM, Jiri Olsa wrote:
> >hum, I've got nothing from babeltrace:
> >
> >[jolsa@krava ~]$ su
> >Password:
> >[root@krava jolsa]# lttng create perf
> >Spawning a session daemon
> >Session perf created.
> >Traces will be written in /root/lttng-traces/perf-20140821-184956
> >[root@krava jolsa]# lttng add-context -k -t prio -t perf:cpu:cycles
> 
> Oh I see the problem, you don't have any events enabled! In LTTng terms, a
> "context" is a piece of information that gets attached to every event. But
> if you don't have any event at all, you're not gonna see much context
> information. ;)
> 
> Try adding a
> # lttng enable-event -a -k
> before starting the session. This should give you some output in the
> viewers.

ugh ;-) 'perf:cpu:cycles' already sounded like event to me.. will try

thanks,
jirka
