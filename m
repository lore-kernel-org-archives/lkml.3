Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab3JKHfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 03:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926Ab3JKHfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 03:35:08 -0400
Date: Fri, 11 Oct 2013 09:34:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
Message-ID: <20131011073448.GA11064@krava.redhat.com>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <20131011055829.GA4975@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011055829.GA4975@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 07:58:29AM +0200, Ingo Molnar wrote:
> 
> * Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > Hello,
> > 
> > This is a new version of callchain improvement patchset.  Basically
> > it's almost same as v4 but rebased on current acme/perf/core and some
> > functions are renamed as Frederic requested.
> > 
> > Now I'm hunting down a bug in 'perf report -s sym' which was found
> > during the test, but I think it's not related to this change as it can
> > be reproduced in earlier versions too.
> > 
> > I put this series on 'perf/callchain-v5' branch in my tree
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> > 
> > Any comments are welcome, thanks.
> 
> One thing I noticed about call-graph profiling:
> 
>   comet:~/tip/tools/perf> ./perf record -g ~/hackbench 10
>   callchain: Unknown -g option value: /home/mingo/hackbench
> 
> I think a naked -g used to work just fine in the past. Even if such an 
> error is displayed the output is very unhelpful, it does does a full 
> perf-record options dump (unnecessary), the bit that is helpful is hidden 
> amongst many other options:
> 
>     -g, --call-graph <mode[,dump_size]>
>                           do call-graph (stack chain/backtrace) recording: [fp] dwarf
> 
> and it took me two reads to see that I should specify 'fp'. The '[fp]' 
> indicates that fp is the default - but that does not appear to be working.

'-g' takes optional parameter, so having it in front of
non option string is causing the error, you could use:

./perf record -g -- ~/hackbench 10

maybe we could display just only help string of the option
we failed to process in this case

jirka
