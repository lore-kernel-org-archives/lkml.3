Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbaKTUqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:46:34 -0500
Received: from one.firstfloor.org ([193.170.194.197]:56115 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884AbaKTUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:46:32 -0500
Date: Thu, 20 Nov 2014 21:46:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org, "Liang, Kan" <kan.liang@intel.com>
Subject: Re: Implement lbr-as-callgraph v10
Message-ID: <20141120204630.GO12538@two.firstfloor.org>
References: <20141117213457.GE4163@kernel.org>
 <20141118104416.GE27645@krava.brq.redhat.com>
 <20141118110007.GF27645@krava.brq.redhat.com>
 <87zjbnpv64.fsf@sejong.aot.lge.com>
 <20141119092323.GC2592@krava.brq.redhat.com>
 <20141119105450.GA22132@krava.brq.redhat.com>
 <20141119141027.GF3790@kernel.org>
 <20141119160458.GG3790@kernel.org>
 <20141119214822.GM12538@two.firstfloor.org>
 <20141120193347.GL3790@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120193347.GL3790@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 04:33:47PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Nov 19, 2014 at 10:48:22PM +0100, Andi Kleen escreveu:
> > On Wed, Nov 19, 2014 at 01:04:58PM -0300, Arnaldo Carvalho de Melo wrote:
> > > Em Wed, Nov 19, 2014 at 11:10:27AM -0300, Arnaldo Carvalho de Melo escreveu:
> > > > Em Wed, Nov 19, 2014 at 11:54:50AM +0100, Jiri Olsa escreveu:
> > > > > > > BUILD_BUG_ON then?
> > > > > > 
> > > > > > sounds gut
> > > > > 
> > > > > hum, acme/perf/core changed and so has the compile error ;-)
> > > > > we dont overload the <linux/bug.h>, so the kernel one got
> > > > > included, which is wrong.. attached patch fixes that
> > > > 
> > > > I had fixed this but not force pushed out, sorry.
> > > > 
> > > > Now I mistakenly tried running:
> > > > 
> > > > perf report --stdio --no-children --branch-history
> > > > 
> > > > on a file that has no BRANCH_STACK, i.e. a perf.data file on a wrong
>  
> > It works with -g.
> 
> What works with -g? perf report?

--branch-history needs perf record -g.
If there is no -g in the record it will error out.

That's what you did and see, right?

> 
> 
> > Without -g it will just give an error message. I think that is ok, isn't it?
>  
> > > > directory since I'm comparing the output of --stdio, --tui and --gtk,
> > > > since it looks --gtk is wrong, still unsure about what the problem is in
> > > > that case, but stumbled on:
> > > > 
> > > 
> > > I need to investigate this further, so I created a perf/branch-history
> > > branch that has the patches I need to test more rebased on top of my
> > > perf/core branch I just pushed out to Ingo.
> > 
> > 
> > I tested --gtk and I don't see any differences to the console mode
> > with --branch-history.  What problem do you see?
> 
> The difference is with --tui, but I haven't checked if this is a problem
> introduced by your patchkit or if this is something that was there
> before it was applied.

What difference do you see?


For me all of --stdio, --gtk, --tui look similar.

-Andi
