Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaJVPHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:07:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45791 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaJVPH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:07:28 -0400
Date: Wed, 22 Oct 2014 17:07:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org,
        mathieu.poirier@linaro.org
Subject: Re: [PATCH v5 06/20] perf: Add AUX record
Message-ID: <20141022150715.GF21513@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-7-git-send-email-alexander.shishkin@linux.intel.com>
 <20141022132608.GM12706@worktop.programming.kicks-ass.net>
 <87fvegdw7e.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvegdw7e.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 05:18:29PM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Mon, Oct 13, 2014 at 04:45:34PM +0300, Alexander Shishkin wrote:
> >> +	/*
> >> +	 * Records that new data landed in the AUX buffer part.
> >> +	 *
> >> +	 * struct {
> >> +	 * 	struct perf_event_header	header;
> >> +	 *
> >> +	 * 	u64				aux_offset;
> >> +	 * 	u64				aux_size;
> >> +	 *	u64				flags;
> >> +	 * 	struct sample_id		sample_id;
> >> +	 * };
> >> +	 */
> >> +	PERF_RECORD_AUX				= 11,
> >
> > Given the discussion with the ARM people the last time, do we want to
> > add the possibility of a variable data field in this event? Its easy to
> > add now, harder to do later (although not impossible).
> 
> Iirc, what they want is to save a once-per-session chunk of data, which
> would be better synthesized by perf record than sent from a pmu driver?
> 
> We do something like that with PT right now, perf record looks at pmu's
> sysfs attributes and stores them in some synthesized record.

Right, I just got to that. So I wasn't entirely sure if perf_event_open
time conditions where sufficient for them, if they are then yes that
could work.
