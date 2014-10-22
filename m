Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbaJVJMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:12:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33151 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbaJVJMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:12:53 -0400
Date: Wed, 22 Oct 2014 11:12:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Liang, Kan" <kan.liang@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v2 0/12] perf/x86: implement HT leak workaround for
 SNB/IVB/HSW
Message-ID: <20141022091239.GG12706@worktop.programming.kicks-ass.net>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
 <20141021112501.GY23531@worktop.programming.kicks-ass.net>
 <CABPqkBTDz56a9Hoy04W6VmTG_FTOE72037D0tmnh+ntw+VW0ZQ@mail.gmail.com>
 <20141021130320.GE12706@worktop.programming.kicks-ass.net>
 <CABPqkBQuf_W1X_VbVzLhKbv6AZwKE3YyHGpT=cRFNBEak5wz_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQuf_W1X_VbVzLhKbv6AZwKE3YyHGpT=cRFNBEak5wz_Q@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 03:08:32PM +0200, Stephane Eranian wrote:
> On Tue, Oct 21, 2014 at 3:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Oct 21, 2014 at 02:28:06PM +0200, Stephane Eranian wrote:
> >> Peter,
> >>
> >> On Tue, Oct 21, 2014 at 1:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> >
> >> >
> >> > lkml.kernel.org/r/CABPqkBRbst4sgpgE5O_VXt-CSC0VD=aP2KWA0e3Uy64tw7df3A@mail.gmail.com
> >> >
> >> > I missed that 3 lines if they were in here.
> >> >
> >> I did not put them in there because there is another problem.
> >> If you partition the generic counters 2 and 2, then some CPUs will not
> >> be able to measure some events.
> >> Unfortunately, there is no way to partition the 4 counters such that
> >> all the events can be measured by
> >> each CPU. Some events or precise sampling requires counter 2 for
> >> instance (like prec_dist).
> >> That's why I did not put this fix in.
> >
> > Ah, I wasn't thinking about a hard partition, just a limit on the number
> > of exclusive counters any one CPU can claim such as to not starve. Or is
> > that what you were talking about? I feel not being able to starve
> > another CPU is more important than a better utilization bound for
> > counter scheduling.
> 
> So you're saying, just limit number of used counters to 2 regardless
> of which one they are. 

used as in marked exclusive and forced empty on the other side.

> So sometimes, this will avoid the problem aforementioned and sometimes
> not. We can try that.

How will this sometimes not avoid the starvation issue?
