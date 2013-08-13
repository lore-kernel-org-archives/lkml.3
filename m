Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab3HMSZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:25:21 -0400
Received: from one.firstfloor.org ([193.170.194.197]:39993 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3HMSZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:25:19 -0400
Date: Tue, 13 Aug 2013 20:25:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, acme@infradead.org, jolsa@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] perf, x86: Report TSX transaction abort cost as
 weight
Message-ID: <20130813182518.GX19750@two.firstfloor.org>
References: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
 <1376010946-28666-3-git-send-email-andi@firstfloor.org>
 <20130813112301.GV27162@twins.programming.kicks-ass.net>
 <20130813143517.GT19750@two.firstfloor.org>
 <20130813152758.GB24092@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813152758.GB24092@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Make it a bigger mess: :-)

Ok.  Only the second union is enough, it only needs the flags,
not the cycles.

> 
> struct hsw_tsx_abort_info {
> 	union {
> 		u64 value;
> 		struct {
> 			u32 cycles_last_tx;
> 			union {
> };
> 
> Also, I think your patch is 'broken' in that it dumps the reserved bits
> out to userspace and this brand spanking new SDM doesn't say they're 0.

Will fix.

> __intel_pmu_pebs_event() isn't getting any prettier with all those
> pebs_format tests; but I'm not seeing anything to really fix that.

Ok. Are you merging your patch with these changes (fll, union) 
or should I send a new one?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
