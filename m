Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaJGPYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:24:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:55843 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaJGPYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:24:17 -0400
Date: Tue, 7 Oct 2014 17:24:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "acme@kernel.org" <acme@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH V5 11/16] perf, core: Pass perf_sample_data to
 perf_callchain()
Message-ID: <20141007152412.GC5850@twins.programming.kicks-ass.net>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
 <1410358153-421-12-git-send-email-kan.liang@intel.com>
 <20140924141507.GF2805@worktop.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F0770160F98C@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F0770160F98C@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you're going to have to stop using outlook or whatnot, this is
horrible.

On Tue, Oct 07, 2014 at 03:00:00AM +0000, Liang, Kan wrote:
> > -----Original Message-----
> > From: Peter Zijlstra [mailto:peterz@infradead.org]

> > So I don't like this. Why not use the regular PERF_SAMPLE_BRANCH_STACK
> > output to generate the stuff from? We already have two different means,
> > with different transport, for callchains anyhow, so a third really won't matter.
> 
> I'm not sure what you mean by using the regular
> PERF_SAMPLE_BRANCH_STACK output to generate the stuff from.  But we
> don't need to modify various architectures' perf_callchain_user, if
> that's your concern.  An alternative way is to generate the callchain
> output in a higher level, like perf_callchain.  If there is no frame
> pointer, the entry->nr will be set to MAX+1. So  the perf_callchain
> knows that we need to try LBR callstack if possible.  In
> perf_callchain, it resets entry->nr to old value, and call
> perf_callchain_lbr_callstack to check and fill the callchain struct if
> possible.  The patch is as below.

Please instruct your MUA to wrap at 78 chars.

What I meant was: why can't we use the regular PERF_SAMPLE_BRANCH_STACK
output to generate user traces from?

PERF_SAMPLE_BRANCH_STACK is the 'normal' LBR output format. Clobbering
the callstack output is bad.

> What do you think?

I think it still sucks.. you're still clobbering potentially more useful
data.
