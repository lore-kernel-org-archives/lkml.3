Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaESNXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:23:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbaESNXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:23:32 -0400
Date: Mon, 19 May 2014 09:20:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/6] perf: Add dcacheline sort
Message-ID: <20140519132002.GH50500@redhat.com>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
 <1399999697-65875-7-git-send-email-dzickus@redhat.com>
 <CABPqkBQE-HLV3JLo4-sXBJos38SY0RUhC-gLeauawrf3Cgojtw@mail.gmail.com>
 <20140516155958.GX11096@twins.programming.kicks-ass.net>
 <CABPqkBS+jx6sR3BNjwGkaG9hZFtfwmLKKiD86Li4hAY_YsTDdA@mail.gmail.com>
 <20140516162441.GA50500@redhat.com>
 <20140519112545.GD5027@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519112545.GD5027@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 01:25:45PM +0200, Jiri Olsa wrote:
> On Fri, May 16, 2014 at 12:24:41PM -0400, Don Zickus wrote:
> > On Fri, May 16, 2014 at 06:02:43PM +0200, Stephane Eranian wrote:
> > > On Fri, May 16, 2014 at 5:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > > On Fri, May 16, 2014 at 04:09:59PM +0200, Stephane Eranian wrote:
> > > >> > +#define CACHE_LINESIZE       64
> > > >> I had something similar to your patch here in my original series for
> > > >> perf mem, but I never pushed it.
> > > >> I think this is a useful feature to have.
> > > >> However, I don't think you can hardcode the cache line size to 64.
> > > >> This is generic
> > > >> code. There may be architectures where the line size is different from 64.
> > > >> So I think you should add an option to change the default line size or provide
> > > >> an arch-specific definition.
> > > >
> > > > # cat /sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size
> > > > 64
> > > Excellent, then we should use that!
> > 
> > Would it make sense to create an accessory function that sets the size in
> > util/cpumap.c and provides it as an inline from util/cpumap.h?
> 
> sounds good,
> 
> btw so far I'll take patches 1-4 (after getting changelog update)
> and expecting v2 for 5,6 ;-)

Ok. Thanks!  What needs to be done for patch 5?  I have a patch 5.5?? that
does the cachline calculation that Stephane requested.  I just have to
find a way to dynamically handle the symbol lengths on output (and fix
that hang you see).

Cheers,
Don
