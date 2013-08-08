Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966726Ab3HHVXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:23:31 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:43748 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966606Ab3HHVXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:23:30 -0400
Date: Thu, 8 Aug 2013 18:23:23 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 01/19] perf: sample after exit loses thread correlation -
 v3
Message-ID: <20130808212323.GA30082@ghostprotocols.net>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
 <1375930261-77273-2-git-send-email-dsahern@gmail.com>
 <20130808145336.GD2851@ghostprotocols.net>
 <520402B9.20003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520402B9.20003@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 08, 2013 at 04:42:33PM -0400, David Ahern escreveu:
> On 8/8/13 10:53 AM, Arnaldo Carvalho de Melo wrote:
> >Em Wed, Aug 07, 2013 at 10:50:43PM -0400, David Ahern escreveu:
> >>Occassionally events (e.g., context-switch, sched tracepoints) are losing
> >>the conversion of sample data associated with a thread. For example:
> >
> >Humm, if we have a tool that traverses the list of threads in a machine
> >it will not know, after one of them exits, about it being dead, so I
> >think this needs to add a thread->dead, no?
> >
> >As of now, from what I can remember, the closest to such a tool would
> >be:
> >
> >  perf top --sort pid
> >
> >But that uses hist_entries that would eventually be decayed as samples
> >would cease to be taken at most a few moments after the EXIT event.
> >
> >But at least for debugging purposes, machine__fprintf() would list dead
> >threads as being present, i.e. alive till its pid gets reused.
> >
> >This is the only, minor, problem that I see with this solution, what do
> >you think?
> 
> I can add the exit timestamp to the thread struct. non-0 means it
> has died. Ok with that as an indicator?

I thought about that, at first looked like overengineering and wasting
some bytes, as we don't have an user for that now, all we need is a
single bit (or bool) just after ->comm_set :-)

If we ever have a use for knowing when the thread exited, no problem in
adding it then.

- Arnaldo
