Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbaEPPTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:19:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbaEPPTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:19:15 -0400
Date: Fri, 16 May 2014 11:18:34 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/6] perf: Add dcacheline sort
Message-ID: <20140516151834.GV50500@redhat.com>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
 <1399999697-65875-7-git-send-email-dzickus@redhat.com>
 <CABPqkBQE-HLV3JLo4-sXBJos38SY0RUhC-gLeauawrf3Cgojtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQE-HLV3JLo4-sXBJos38SY0RUhC-gLeauawrf3Cgojtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 04:09:59PM +0200, Stephane Eranian wrote:
> > diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> > index 635cd8f..0e91ba9 100644
> > --- a/tools/perf/util/sort.c
> > +++ b/tools/perf/util/sort.c
> > @@ -1,3 +1,4 @@
> > +#include <sys/mman.h>
> >  #include "sort.h"
> >  #include "hist.h"
> >  #include "comm.h"
> > @@ -764,6 +765,102 @@ static int hist_entry__snoop_snprintf(struct hist_entry *he, char *bf,
> >         return repsep_snprintf(bf, size, "%-*s", width, out);
> >  }
> >
> > +#define CACHE_LINESIZE       64
> I had something similar to your patch here in my original series for
> perf mem, but I never pushed it.
> I think this is a useful feature to have.
> However, I don't think you can hardcode the cache line size to 64.
> This is generic
> code. There may be architectures where the line size is different from 64.
> So I think you should add an option to change the default line size or provide
> an arch-specific definition.

I agree.  I'll dig up a way to do that.  Thanks!

Cheers,
Don
