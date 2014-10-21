Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621AbaJUNJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:09:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbaJUNJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:09:04 -0400
Date: Tue, 21 Oct 2014 15:03:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Liang, Kan" <kan.liang@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v2 0/12] perf/x86: implement HT leak workaround for
 SNB/IVB/HSW
Message-ID: <20141021130320.GE12706@worktop.programming.kicks-ass.net>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
 <20141021112501.GY23531@worktop.programming.kicks-ass.net>
 <CABPqkBTDz56a9Hoy04W6VmTG_FTOE72037D0tmnh+ntw+VW0ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTDz56a9Hoy04W6VmTG_FTOE72037D0tmnh+ntw+VW0ZQ@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 02:28:06PM +0200, Stephane Eranian wrote:
> Peter,
> 
> On Tue, Oct 21, 2014 at 1:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >
> > lkml.kernel.org/r/CABPqkBRbst4sgpgE5O_VXt-CSC0VD=aP2KWA0e3Uy64tw7df3A@mail.gmail.com
> >
> > I missed that 3 lines if they were in here.
> >
> I did not put them in there because there is another problem.
> If you partition the generic counters 2 and 2, then some CPUs will not
> be able to measure some events.
> Unfortunately, there is no way to partition the 4 counters such that
> all the events can be measured by
> each CPU. Some events or precise sampling requires counter 2 for
> instance (like prec_dist).
> That's why I did not put this fix in.

Ah, I wasn't thinking about a hard partition, just a limit on the number
of exclusive counters any one CPU can claim such as to not starve. Or is
that what you were talking about? I feel not being able to starve
another CPU is more important than a better utilization bound for
counter scheduling.
