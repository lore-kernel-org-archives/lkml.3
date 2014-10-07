Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaJGPPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:15:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43107 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaJGPPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:15:23 -0400
Date: Tue, 7 Oct 2014 17:15:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 02/22] perf: Add AUX area to ring buffer for raw data
 streams
Message-ID: <20141007151515.GA5850@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-3-git-send-email-alexander.shishkin@linux.intel.com>
 <20140908070242.GS19379@twins.programming.kicks-ass.net>
 <87lhpuuztj.fsf@ashishki-desk.ger.corp.intel.com>
 <20140908113422.GD6758@twins.programming.kicks-ass.net>
 <87a96auv9s.fsf@ashishki-desk.ger.corp.intel.com>
 <20140908131230.GE6758@twins.programming.kicks-ass.net>
 <87k34do9a4.fsf@ashishki-desk.ger.corp.intel.com>
 <20141006162056.GD6758@twins.programming.kicks-ass.net>
 <87a958q30u.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a958q30u.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 12:52:49AM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:

> > No, and I think I realized this after sending that email, but at the
> > time I figured there was another way to do it. Of course, now that
> > several weeks have passed I cannot for the life of me remember what it
> > was.
> >
> > Lemme go over these patches again to refresh my mind and maybe I'll
> > remember.
> 
> Yes, ring buffer can keep a refcount for the aux_priv object, which is
> grabbed once at mmap and once at perf_aux_output_begin() and released
> accordingly and whichever drops the refcount to zero calls
> pmu::free_aux. No need to grab page->_count and driver is a bit simpler.

Yes, I suppose that'll work just fine.
