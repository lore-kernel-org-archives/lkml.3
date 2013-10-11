Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3JKF6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:58:34 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:44988 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3JKF6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:58:33 -0400
Date: Fri, 11 Oct 2013 07:58:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
Message-ID: <20131011055829.GA4975@gmail.com>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> Hello,
> 
> This is a new version of callchain improvement patchset.  Basically
> it's almost same as v4 but rebased on current acme/perf/core and some
> functions are renamed as Frederic requested.
> 
> Now I'm hunting down a bug in 'perf report -s sym' which was found
> during the test, but I think it's not related to this change as it can
> be reproduced in earlier versions too.
> 
> I put this series on 'perf/callchain-v5' branch in my tree
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> Any comments are welcome, thanks.

One thing I noticed about call-graph profiling:

  comet:~/tip/tools/perf> ./perf record -g ~/hackbench 10
  callchain: Unknown -g option value: /home/mingo/hackbench

I think a naked -g used to work just fine in the past. Even if such an 
error is displayed the output is very unhelpful, it does does a full 
perf-record options dump (unnecessary), the bit that is helpful is hidden 
amongst many other options:

    -g, --call-graph <mode[,dump_size]>
                          do call-graph (stack chain/backtrace) recording: [fp] dwarf

and it took me two reads to see that I should specify 'fp'. The '[fp]' 
indicates that fp is the default - but that does not appear to be working.

Another thing I noticed is that there are a fair number of conflicts 
against perf/core, and some more against Arnaldo's tree.

Otherwise it seems to be working well!

Thanks,

	Ingo

