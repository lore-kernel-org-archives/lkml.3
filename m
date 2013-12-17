Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3LQOmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:42:35 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:34367 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3LQOmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:42:33 -0500
Date: Tue, 17 Dec 2013 15:42:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Shi <alex.shi@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/4] Fix ebizzy performance regression due to X86 TLB
 range flush v2
Message-ID: <20131217144214.GA12370@gmail.com>
References: <1386964870-6690-1-git-send-email-mgorman@suse.de>
 <CA+55aFyNAigQqBk07xLpf0nkhZ_x-QkBYG8otRzsqg_8A2eg-Q@mail.gmail.com>
 <20131215155539.GM11295@suse.de>
 <20131216102439.GA21624@gmail.com>
 <20131216125923.GS11295@suse.de>
 <20131216134449.GA3034@gmail.com>
 <20131217092124.GV11295@suse.de>
 <20131217110051.GA27701@gmail.com>
 <20131217143253.GB11295@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217143253.GB11295@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> [...]
>
> At that point it'll be time to look at profiles and see where we are 
> actually spending time because the possibilities of finding things 
> to fix through bisection will be exhausted.

Yeah.

One (heavy handed but effective) trick that can be used in such a 
situation is to just revert everything that is causing problems, and 
continue reverting until we get back to a v3.4 baseline performance.

Once such a 'clean' tree (or queue of patches) is achived, that can be 
used as a measurement base and the individual features can be 
re-applied again, one by one, with measurement and analysis becoming a 
lot easier.

> > Also it appears the Ebizzy numbers ought to be stable enough now 
> > to make the range-TLB-flush measurements more precise?
> 
> Right now, the tlbflush microbenchmark figures look awful on the 
> 8-core machine when the tlbflush shift patch and the schedule domain 
> fix are both applied.

I think that furthr strengthens the case for the 'clean base' approach 
I outlined above - but it's your call obviously ...

Thanks again for going through all this. Tracking multi-commit 
performance regressions across 1.5 years worth of commits is generally 
very hard. Does your testing effort comes from enterprise Linux QA 
testing, or did you ran into this problem accidentally?

Thanks,

	Ingo
