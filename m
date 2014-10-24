Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbaJXNCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:02:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45350 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbaJXNCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:02:42 -0400
Date: Fri, 24 Oct 2014 15:02:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 12/20] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20141024130228.GM3219@twins.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-13-git-send-email-alexander.shishkin@linux.intel.com>
 <20141022144543.GV12706@worktop.programming.kicks-ass.net>
 <87tx2t27yb.fsf@ashishki-desk.ger.corp.intel.com>
 <20141024115131.GY21513@worktop.programming.kicks-ass.net>
 <87wq7pd5sw.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wq7pd5sw.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 03:13:19PM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Fri, Oct 24, 2014 at 11:22:20AM +0300, Alexander Shishkin wrote:
> >> > The fact that the hardware cannot even tell you the supported mask is
> >> > further fail.
> >
> >> The problem with this is that some bits go in groups, there'd be 2..3..4
> >> bit fields encoding desired packet frequency, for example.
> >
> > OK, so put the magic number in the big model array.
> 
> I'm not sure I follow. These bits are reserved for the future, they can
> potentially be whatever combinations of whatever. If we want to probe
> around for valid combinations is to check everything in the range of
> 0..2^43 (or something like that, the region reserved for packet enables)
> and store all the valid ones, which sounds crazy.

I was assuming that the accepted bits are model specific, and we have
this big model switch statement in perf_event_intel.c:intel_pmu_init(),
so why not have something like x86_pmu.pt_magic_bitmask = 0xf00d in
there?

No need to probe in that case. That is the same thing we do for all
unenumerated model specific things.
