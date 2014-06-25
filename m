Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaFYMMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:12:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57518 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbaFYMMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:12:08 -0400
Date: Wed, 25 Jun 2014 14:11:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC v2 2/7] perf: add AUX area to ring buffer for raw data
 streams
Message-ID: <20140625121156.GA3935@laptop>
References: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1402501310-31940-3-git-send-email-alexander.shishkin@linux.intel.com>
 <20140624171943.GR3213@twins.programming.kicks-ass.net>
 <87lhslxn2s.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhslxn2s.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 02:09:31PM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Wed, Jun 11, 2014 at 06:41:45PM +0300, Alexander Shishkin wrote:
> >> +	/*
> >> +	 * Set up pmu-private data structures for an AUX area
> >> +	 */
> >> +	void *(*setup_aux)		(int cpu, void **pages,
> >> +					 int nr_pages, bool overwrite);
> >> +					/* optional */
> >> +
> >> +	/*
> >> +	 * Free pmu-private AUX data structures
> >> +	 */
> >> +	void (*free_aux)		(void *aux); /* optional */
> >
> > I was hoping you could replace those with a PERF_CAP_AUX or something
> > and then have one generic allocation routine like you provide in the
> > subsequent patches.
> 
> I need these to allocate pmu-specific SG tables now, which I don't see
> how to generalize nicely. User-visible aux_pages are allocated in the
> generic rb_alloc_aux().
> 
> As for sg tables, the alternative would be to allocate them in the
> event::pmu::add() path, which is probably not very good for
> performance, unless I'm missing something? Like, I can allocate stuff in
> the first add() and then free it in event::destroy().
> 
> Or, we can assume a generic sg table format and allocate them in the
> generic code, but then we'll need more capabilities to indicate at least
> the size of a table entry. PT needs 64 bits per entry, ARM's TMC needs
> 32 and the non-SG PT will still need some tables. But I'd rather leave
> this part to the pmu drivers. What do you think?

Ah, I wasn't aware.. too bad. Maybe add this to the changelog.
