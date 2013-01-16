Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3APO0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:26:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab3APO0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:26:22 -0500
Date: Wed, 16 Jan 2013 15:25:49 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [RFC 0/4] perf tool: Adding ratios support
Message-ID: <20130116142549.GD1042@krava.brq.redhat.com>
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
 <CAOPLpQeHTCwr4tuHi0nORCn+LKJRzEGoCWhC-rj30nLe7bY5Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOPLpQeHTCwr4tuHi0nORCn+LKJRzEGoCWhC-rj30nLe7bY5Nw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 09:00:07AM -0500, Ulrich Drepper wrote:
> On Tue, Jan 15, 2013 at 8:39 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> >   $ perf stat -f formula.conf:cpi kill
> >   usage: kill [ -s signal | -p ] [ -a ] pid ...
> >          kill -l [ signal ]
> 
> I do like this proposal.  The only comment I have is that perhaps the
> command line syntax isn't ideal.  What you use above is tied to the
> ratios be defined in the config file.  I would imagine that at least
> over time (for some ratios probably right away) they become available
> by default and don't require a config file.  Also, users might want to
> put individualized ratio definitions in a config file which is read by
> default.
> 
> How about the formulas becoming available whenever the config file is
> read.  Maybe this means a few more keywords in the config file (ratio,
> ratio-set, ...).  E.g.:
> 
> ratio-set branch {
>           events = {instructions,branch-instructions,branch-misses}:u
> 
>           ratio branch-rate {
>                   formula = branch-instructions / instructions
>                   desc = branch rate
>           }
> 
>           ratio branch-miss-rate {
>                   formula = branch-misses / instructions
>                   desc = branch misprediction rate
>           }
> 
>           ratio branch-miss-ratio{
>                   formula = branch-misses / branch-instructions
>                   desc = branch misprediction ratio
>           }
>   }

I was thinking having config files (global and arch specific)
comming with perf having predefined formulas.

Plus adding the possibility to load extra config file via command
line option.

> 
> You get the idea.  Maybe substitute "ratio":with "formula". Then allow
> such a ratio/formula to be used just like a normal event, perhaps with
> a special suffix/prefix to designate it.  This should then also mark

I like the idea of having ratios handled within event definitions
maybe even in a similar way like aliases are handled today.. like:

1)  -e 'ratio/branch-rate/'  # special event class
2)  -e 'ratio-branch-rate'   # 'ratio-' prefix
3)  -e cpu/branch-rate/      # handled like aliases, ratio name would need to be unique 
  ... ?

ideas?

Having both 2) with 3) seems good to me

> the events as part of a group so that the underlying counters are
> scheduled in together.

the 'events' definitions could be put into group by default,
meanwhile I used 'events = { ... }'

thanks,
jirka
