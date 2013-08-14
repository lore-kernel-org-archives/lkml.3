Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438Ab3HNJdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:33:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49097 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3HNJdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:33:43 -0400
Date: Wed, 14 Aug 2013 11:33:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, acme@infradead.org,
        jolsa@redhat.com, eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] perf, x86: Report TSX transaction abort cost as
 weight
Message-ID: <20130814093330.GG24092@twins.programming.kicks-ass.net>
References: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
 <1376010946-28666-3-git-send-email-andi@firstfloor.org>
 <20130813112301.GV27162@twins.programming.kicks-ass.net>
 <20130813143517.GT19750@two.firstfloor.org>
 <20130813152758.GB24092@twins.programming.kicks-ass.net>
 <20130813182518.GX19750@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813182518.GX19750@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 08:25:18PM +0200, Andi Kleen wrote:
> > Make it a bigger mess: :-)
> 
> Ok.  Only the second union is enough, it only needs the flags,
> not the cycles.
> 
> > 
> > struct hsw_tsx_abort_info {
> > 	union {
> > 		u64 value;
> > 		struct {
> > 			u32 cycles_last_tx;
> > 			union {
> > };
> > 
> > Also, I think your patch is 'broken' in that it dumps the reserved bits
> > out to userspace and this brand spanking new SDM doesn't say they're 0.
> 
> Will fix.
> 
> > __intel_pmu_pebs_event() isn't getting any prettier with all those
> > pebs_format tests; but I'm not seeing anything to really fix that.
> 
> Ok. Are you merging your patch with these changes (fll, union) 
> or should I send a new one?

Please send a new one that is actually tested. Mine didn't see a
compiler up close nor do I have the hardware to verify it actually does
something sane.
