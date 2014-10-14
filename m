Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbaJNTYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 15:24:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340AbaJNTYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 15:24:43 -0400
Date: Tue, 14 Oct 2014 16:24:38 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH v2] perf tools: fix off-by-one error in maps
Message-ID: <20141014192438.GA6234@redhat.com>
References: <20141006083532.GA4850@quad>
 <8761fwh1nc.fsf@sejong.aot.lge.com>
 <20141007140050.GB2256@redhat.com>
 <CABPqkBSMapWzo5k7WXpt8Ejtdvk_znX1P6xV0eYRpK7rcTjjZw@mail.gmail.com>
 <20141007151035.GC2256@redhat.com>
 <CABPqkBR2FzTvkRsTH91hYbt7H-BDZ2kcnF1xDqKBB0h=2HSapw@mail.gmail.com>
 <20141014185829.GA3839@redhat.com>
 <CABPqkBRCYgEo=4zS4dZDbdnbA_+4otKFA5oFgczdWqpahM0smg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRCYgEo=4zS4dZDbdnbA_+4otKFA5oFgczdWqpahM0smg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 14, 2014 at 09:03:02PM +0200, Stephane Eranian escreveu:
> On Tue, Oct 14, 2014 at 8:58 PM, Arnaldo Carvalho de Melo
> > struct vm_area_struct {
> >         /* The first cache line has the info for VMA tree walking. */

> >         unsigned long vm_start;         /* Our start address within vm_mm. */
> >         unsigned long vm_end;           /* The first byte after our end address
> >                                            within vm_mm. */

> > So these guys have been doing this far longer than me, I guess I'll bow
> > to this convention.

> > But by renaming map->end to map->end_ and looking at all the usage of
> > it, there are some inconsistencies...

> > Like symbol->{start,end} is of the [start,end] case, and to be
> > consistent with above needs to also move to [start,end[, will cook a
> > patch and send for review.

> Yes, there were some inconsistencies (or confusions) that I noticed when
> I started fixing the maps. I can believe that this off-by-one error exist with
> other data types. That could cause wrong symbol correlations in borderline
> cases (which are really rare).

Yeah, I'll try and fix one by one in separate patches when applicable.

- Arnaldo
