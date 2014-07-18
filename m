Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935070AbaGROnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:43:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbaGROnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:43:24 -0400
Date: Fri, 18 Jul 2014 16:42:48 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Sahasrabudhe, Sheetal" <sheetals@quicinc.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: perf: child events not killed on release paths, survive
 indefinitely
Message-ID: <20140718144248.GA29768@krava.redhat.com>
References: <20140718123238.GF25180@leverpostej>
 <20140718140343.GC20603@laptop.programming.kicks-ass.net>
 <20140718143157.GB17328@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718143157.GB17328@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 03:31:57PM +0100, Mark Rutland wrote:

SNIP

> > > I'm not sure what the best way of handling this is. We need to clean up
> > > the children when the last possible user of the event is gone, but it
> > > looks to me like we'd need to have a separate child_refcount or
> > > reader_refcount to be able to tell when the events are still useful and
> > > when the only references which remain are internal.
> > > 
> > > Any ideas?
> > 
> > Jiri was recently poking at that:
> > 
> > lkml.kernel.org/r/1405079782-8139-3-git-send-email-jolsa@kernel.org
> 
> Ah. I hadn't spotted that, thanks for the link.
> 
> That approach (closing child events when the owner exits) doesn't seem
> to fix the general case, as long running tasks (think interactive
> debugger/profiler) could open and close many events before exiting, if
> nothing else wasting memory until it does so.
> 
> My test case triggers with said patch applied (before hanging, probably
> due to the AB-BA deadlock).

yep, peter already found that
http://marc.info/?l=linux-kernel&m=140541548218652&w=2

> 
> Jiri, could you add me to Cc for future versions of that series?
> 
> I'll have a look and see if I can come up with something; otherwise I'm
> happy to test/review. :)

sure, and vice versa ;-)

jirka
