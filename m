Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab3JKI7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:59:49 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:48134 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab3JKI7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:59:32 -0400
Date: Fri, 11 Oct 2013 10:58:09 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC/PATCH] ftrace: add set_graph_notrace filter
Message-ID: <20131011085809.GD4154@osiris>
References: <1378184708-31385-1-git-send-email-namhyung@kernel.org>
 <20131011001717.26b92150@gandalf.local.home>
 <20131011072156.GC4154@osiris>
 <871u3scik4.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u3scik4.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101108-4966-0000-0000-000007289608
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 05:34:19PM +0900, Namhyung Kim wrote:
> Hi Heiko,
> 
> On Fri, 11 Oct 2013 09:21:56 +0200, Heiko Carstens wrote:
> > On Fri, Oct 11, 2013 at 12:17:17AM -0400, Steven Rostedt wrote:
> >> Isn't there a way we could pass the state? Hmm, I think we could use
> >> depth to do that. As depth is a pointer to trace.depth and not used
> >> before then. We could make it negative and then check that.
> >> 
> >> /me looks at other archs.
> >> 
> >> Darn it, s390 calls ftrace_push_return_trace() before
> >> ftrace_graph_entry(). They got fancy, as they must have noticed that
> >> trace.depth is set by ftrace_push_return_trace() and they just figured
> >> to let the ftrace_push_return_trace() do the work.
> >> 
> >> Hmm, we could add a config to do the check on one side or the other
> >> depending on how the arch handles it.
> >> 
> >> It needs to be well commented though.
> >
> > I don't remember I why decided to do that more than four years ago, however
> > on the other hand I really don't think we need a config for this.
> > So I just committed the patch below... it compiles and doesn't crash
> > immediately, so must be good.
> > It will be merged during the next merge window.
> 
> Nice!
> 
> >
> > From 8c539d10400ee2efe000d324497a0661a2143dbf Mon Sep 17 00:00:00 2001
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Date: Fri, 11 Oct 2013 08:55:57 +0200
> > Subject: [PATCH] s390/ftrace: prepare_ftrace_return() function call order
> >
> > Steven Rostedt noted that s390 is the only architecture which calls
> > ftrace_push_return_trace() before ftrace_graph_entry() and therefore has
> > the small advantage that trace.depth gets initialized automatically.
> 
> Well, this is not true.  AFAICS arm, x86 and powerpc have same order, and
> other archs have different (inverted) order.  And it'd really great if
> all archs agreed on a single ordering.

Ooops. Anyway.. I just realized that we also have an out-of-tree patch
that relies on the now new order on s390. So that patch got a bit smaller
as an added bonus ;)

