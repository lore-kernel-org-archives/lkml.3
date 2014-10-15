Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaJOTYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:24:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:60878 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaJOTYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:24:46 -0400
Date: Wed, 15 Oct 2014 16:24:41 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/5] perf tools: Speed up dwarf callchain
 post-unwinding for libunwind (v4)
Message-ID: <20141015192441.GR3198@kernel.org>
References: <1412556363-26229-1-git-send-email-namhyung@kernel.org>
 <20141013181158.GA28191@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013181158.GA28191@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 13, 2014 at 08:11:58PM +0200, Jiri Olsa escreveu:
> On Mon, Oct 06, 2014 at 09:45:58AM +0900, Namhyung Kim wrote:
> > Hello,
> > 
> > This is v4 for libunwind callchain post processing speed up.  It was
> > able to reduce 50% of processing time by using global cache provided
> > in libunwind.  In this version, I decided to use the existing
> > callchain_param.record_mode instead of adding a new field in the
> > symbol_conf.
> > 
> > The patch 4 and 5 are just cleanups so that we can easily find out
> > that which part of code uses the thread->priv.
> > 
> > You can also get it from 'perf/callchain-unwind-v4' branch on my tree:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> > 
> > Thanks,
> > Namhyung
> > 
> > 
> > Namhyung Kim (5):
> >   perf report: Set callchain_param.record_mode for future use
> >   perf callchain: Create an address space per thread
> >   perf callchain: Use global caching provided by libunwind
> >   perf kvm: Use thread_{,_set}_priv helpers
> >   perf trace: Use thread_{,_set}_priv helpers
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied.

- Arnaldo
