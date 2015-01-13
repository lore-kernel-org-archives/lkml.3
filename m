Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbbAMQ1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:27:40 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:43057 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbbAMQ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:27:39 -0500
Date: Tue, 13 Jan 2015 17:27:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org
Subject: Re: [PATCH v8 12/14] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20150113162720.GL25256@twins.programming.kicks-ass.net>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1415972627-37514-13-git-send-email-alexander.shishkin@linux.intel.com>
 <20150109124824.GL3337@twins.programming.kicks-ass.net>
 <87sifen2d5.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sifen2d5.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 05:09:58PM +0200, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Fri, Nov 14, 2014 at 03:43:45PM +0200, Alexander Shishkin wrote:
> >> +static void pt_event_stop(struct perf_event *event, int mode)
> >> +{
> >> +	struct pt *pt = this_cpu_ptr(&pt_ctx);
> >> +
> >> +	ACCESS_ONCE(pt->handle_nmi) = 0;
> >
> > Why is this needed? Will the hardware still generate interrupts if you
> > stop the PT thing?
> 
> Actually, it turns out that the interrupt condition can race with the
> wrmsr that disables tracing and the PT bit remains set in the global
> status register, causing the next PMI to go into the PT PMI handler,
> which then may decide to re-enable the counter that should be disabled.

OK, please add this information in a suitably placed comment.

Thanks!
