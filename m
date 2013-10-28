Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab3J1RBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:01:24 -0400
Received: from mail-gg0-f178.google.com ([209.85.161.178]:33567 "EHLO
	mail-gg0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3J1RBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:01:23 -0400
Date: Mon, 28 Oct 2013 14:01:11 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf tools: Add new comm infrastructure
Message-ID: <20131028170111.GG16948@ghostprotocols.net>
References: <526A8F54.2040601@gmail.com>
 <CAFTL4hzX=0-_gK6E9V7oH3hrrCerVn_s8TVBsDspzLvpQEmtpw@mail.gmail.com>
 <526AB61B.80505@gmail.com>
 <871u369cq0.fsf@sejong.aot.lge.com>
 <CAFTL4hxbfJy9Tfw2j5ptW5k5AjCBYSuf5_+7U9ShWUQaDqOpdw@mail.gmail.com>
 <8738nl92oh.fsf@sejong.aot.lge.com>
 <20131028101248.GA6491@localhost.localdomain>
 <20131028124309.GE16948@ghostprotocols.net>
 <20131028142912.GF16948@ghostprotocols.net>
 <20131028160528.GA10452@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028160528.GA10452@localhost.localdomain>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 28, 2013 at 05:05:30PM +0100, Frederic Weisbecker escreveu:
> On Mon, Oct 28, 2013 at 11:29:12AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Oct 28, 2013 at 09:43:09AM -0300, Arnaldo Carvalho de Melo escreveu:
> > > Em Mon, Oct 28, 2013 at 11:12:50AM +0100, Frederic Weisbecker escreveu:
> > > > On Mon, Oct 28, 2013 at 06:15:26PM +0900, Namhyung Kim wrote:
> > > > > On Mon, 28 Oct 2013 10:09:46 +0100, Frederic Weisbecker wrote:
> > > > > > Ah cool! Could you please remind me the name of that branch so that I
> > > > > > can do some tests and work on top of it?
> > 
> > > > >   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> > > > >     perf/callchain-v5
> > 
> > > > Hmm, I tried to rebase on top of tip:perf/core and git is getting confused I guess with
> > > > which is applied and which is out of tree. There have been a lot of changes since
> > > > then and thus quite some conflicts.
> > > > 
> > > > If you don't mind, I would love if you rebase against latest tip:perf/core as you
> > > > know better than me what has been applied and what hasn't.
> >  
> > > I'll try to do it now.
> > 
> > Can you please try with:
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
> > 	  perf/comm
> > 
> > And share your results? I fixed up everything wrt recent flux in my
> > perf/core branch, did just basic testing here, but so far it looks ok
> > (and fast!).
> 
> Ok I tried perf report, perf script and perf top and it looks good.
> In fact it looks better than the tip tree. I fixes some bugs that I can

tip.tip has the borked disabling of MMAP2 that may explain some of the
problems you described here

> see in tip:/perf/core:
> 
>      $ perf record perf bench sched messaging
>      $ perf report --stdio -s comm
>      write failure on standard output: Bad file descriptor
> 
> Not sure where that comes from, but it's fixed in your tree. May be that's
> on the fixes before the comm patches in your tree.
> 
> Also it differentiate between pre-exec and post-fork events, which looks
> more precise (and it fixes some comm mangling as well):
> 
> 
> Before:
> 
>      # Overhead          Command
>      # ........  ...............
>      #
>        100.00%  sched-me

I noticed the above, just on the --stdio tho, checking why this is so...
Can you try without --stdio, even using --tui?

- Arnaldo

> 
> After:
> 
>      # Overhead          Command
>      # ........  ...............
>      #
>         99.89%  sched-messaging
>         0.11%             perf
> 
> 
> Thanks!
