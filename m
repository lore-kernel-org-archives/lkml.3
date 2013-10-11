Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab3JKM7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:59:41 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:33903 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3JKM7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:59:39 -0400
Date: Fri, 11 Oct 2013 14:59:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
Message-ID: <20131011125935.GA10634@gmail.com>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <20131011055829.GA4975@gmail.com>
 <20131011073448.GA11064@krava.redhat.com>
 <8761t4cizo.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761t4cizo.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Jiri,
> 
> On Fri, 11 Oct 2013 09:34:48 +0200, Jiri Olsa wrote:
> > On Fri, Oct 11, 2013 at 07:58:29AM +0200, Ingo Molnar wrote:
> >> 
> >> * Namhyung Kim <namhyung@kernel.org> wrote:
> >> 
> >> > Hello,
> >> > 
> >> > This is a new version of callchain improvement patchset.  Basically
> >> > it's almost same as v4 but rebased on current acme/perf/core and some
> >> > functions are renamed as Frederic requested.
> >> > 
> >> > Now I'm hunting down a bug in 'perf report -s sym' which was found
> >> > during the test, but I think it's not related to this change as it can
> >> > be reproduced in earlier versions too.
> >> > 
> >> > I put this series on 'perf/callchain-v5' branch in my tree
> >> > 
> >> >   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> >> > 
> >> > Any comments are welcome, thanks.
> >> 
> >> One thing I noticed about call-graph profiling:
> >> 
> >>   comet:~/tip/tools/perf> ./perf record -g ~/hackbench 10
> >>   callchain: Unknown -g option value: /home/mingo/hackbench
> >> 
> >> I think a naked -g used to work just fine in the past. Even if such an 
> >> error is displayed the output is very unhelpful, it does does a full 
> >> perf-record options dump (unnecessary), the bit that is helpful is hidden 
> >> amongst many other options:
> >> 
> >>     -g, --call-graph <mode[,dump_size]>
> >>                           do call-graph (stack chain/backtrace) recording: [fp] dwarf
> >> 
> >> and it took me two reads to see that I should specify 'fp'. The '[fp]' 
> >> indicates that fp is the default - but that does not appear to be working.
> >
> > '-g' takes optional parameter, so having it in front of
> > non option string is causing the error, you could use:
> >
> > ./perf record -g -- ~/hackbench 10
> 
> Yes, I think this is an unfortunate change to break some user's scripts.  
> It'd be great if it detect whether the next argument belongs to the 
> option, or if not, pass it to next normally - but it seems to be not so 
> simple IMHO.

So, why not keep -g as a shortcut to whatever default call-graph profiling 
we want to provide (note, this does not mean it always has to be 'fp'), 
and use --call-graph for more specific variants?

a .perfconfig value could even set the default for '-g', so that you don't 
have to type '--call-graph dwarf' all the time.

Thanks,

	Ingo
