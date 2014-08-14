Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaHNSlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:41:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:15046 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbaHNSla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:41:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,864,1400050800"; 
   d="scan'208";a="468820758"
Date: Thu, 14 Aug 2014 11:41:15 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4/5] perf, x86: Add INST_RETIRED.ALL workarounds
Message-ID: <20140814184115.GS5803@tassilo.jf.intel.com>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
 <1407979069-7121-5-git-send-email-andi@firstfloor.org>
 <CABPqkBTnZ8SF8TPPMxcY+jPvwQhv+3gki86dnNVgBbAJ_RPdkg@mail.gmail.com>
 <20140814143009.GO5803@tassilo.jf.intel.com>
 <CABPqkBQVwGH7GAVXAXjR1inWnWYeWuVG7Aj-aWAzAksdGq8oeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQVwGH7GAVXAXjR1inWnWYeWuVG7Aj-aWAzAksdGq8oeg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 07:47:56PM +0200, Stephane Eranian wrote:
> [+perf tool maintainers]
> 
> On Thu, Aug 14, 2014 at 4:30 PM, Andi Kleen <ak@linux.intel.com> wrote:
> >
> > I understand all your points, but there's no alternative.
> > The only other way would be to disable INST_RETIRED.ALL.
> >
> You cannot do that either. INST_RETIRED:ALL is important.
> I assume the bug applies whether or not the event is used
> with a filter.

> 
> I think we need to ensure that by looking at the perf.data file,
> one can reconstruct the total number of inst_Retired:all
> occurrences for the run. With a fixed period, one would do
> num_samples * fixed_period. I know the Gooda tool does
> that. It is used to estimate the number of events captured
> vs. the number of events occurring.

Is that really a problem?

Normally periods are not that small, especially not for 
instruction retired. I don't think you can run such
a small period on instruction retired for
any significant time without throttling.

With sensible periods, let's say >10k, the error from
losing a few bits is very small. It would surprise
me if you can actually measure it.

There will be always much more jitter just from standard
system noise.

-Andi
