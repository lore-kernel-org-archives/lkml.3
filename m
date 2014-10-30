Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980AbaJ3NbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:31:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54417 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759803AbaJ3NbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:31:13 -0400
Date: Thu, 30 Oct 2014 11:31:00 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com
Subject: Re: [PATCH v5 18/20] perf: Allocate ring buffers for inherited
 per-task kernel events
Message-ID: <20141030133100.GB1313@kernel.org>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-19-git-send-email-alexander.shishkin@linux.intel.com>
 <20141023123855.GC12706@worktop.programming.kicks-ass.net>
 <87egtx3o95.fsf@ashishki-desk.ger.corp.intel.com>
 <20141030084359.GD23531@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030084359.GD23531@worktop.programming.kicks-ass.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 30, 2014 at 09:43:59AM +0100, Peter Zijlstra escreveu:
> On Fri, Oct 24, 2014 at 10:44:54AM +0300, Alexander Shishkin wrote:
> > Peter Zijlstra <peterz@infradead.org> writes:
> > > On Mon, Oct 13, 2014 at 04:45:46PM +0300, Alexander Shishkin wrote:
> > >> When a new event is inherited from a per-task kernel event that has a
> > >> ring buffer, allocate a new buffer for this event so that data from the
> > >> child task is collected and can later be retrieved for sample annotation
> > >> or core dump inclusion. This ring buffer is released when the event is
> > >> freed, for example, when the child task exits.

> > > This causes a pinned memory explosion, not at all nice that.

> > > I think I see why and all, but it would be ever so good to not have to
> > > allocate so much memory.

> > Are there any controls we could use to limit such memory usage?

> I'd say the same limit we're already accounting the mmap()s against. But
> the question is; what do we do when we run out?

> Will we fail clone()? That might 'surprise' quite a few people, that

> their application won't work when profiled.

Can't we just emit PERF_RECORD_THROTTLE or similar stuff then? I.e.
somehow mark the cloned process as not being profiled due to ENOMEM?

- Arnaldo
