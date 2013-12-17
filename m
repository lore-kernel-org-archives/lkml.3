Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3LQRyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 12:54:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab3LQRyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:54:45 -0500
Date: Tue, 17 Dec 2013 17:54:41 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Shi <alex.shi@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/4] Fix ebizzy performance regression due to X86 TLB
 range flush v2
Message-ID: <20131217175441.GI11295@suse.de>
References: <1386964870-6690-1-git-send-email-mgorman@suse.de>
 <CA+55aFyNAigQqBk07xLpf0nkhZ_x-QkBYG8otRzsqg_8A2eg-Q@mail.gmail.com>
 <20131215155539.GM11295@suse.de>
 <20131216102439.GA21624@gmail.com>
 <20131216125923.GS11295@suse.de>
 <20131216134449.GA3034@gmail.com>
 <20131217092124.GV11295@suse.de>
 <20131217110051.GA27701@gmail.com>
 <20131217143253.GB11295@suse.de>
 <20131217144214.GA12370@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131217144214.GA12370@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 03:42:14PM +0100, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > [...]
> >
> > At that point it'll be time to look at profiles and see where we are 
> > actually spending time because the possibilities of finding things 
> > to fix through bisection will be exhausted.
> 
> Yeah.
> 
> One (heavy handed but effective) trick that can be used in such a 
> situation is to just revert everything that is causing problems, and 
> continue reverting until we get back to a v3.4 baseline performance.
> 

Very tempted but the potential timeframe here is very large and the number
of patches could be considerable. Some patches cause a lot of noise. For
example, one patch enabled ACPI cpufreq driver loading which looks like
a regression during that window but it's a side-effect that gets fixed
later. It'll take time to identify all the patches that potentially cause
problems.

> Once such a 'clean' tree (or queue of patches) is achived, that can be 
> used as a measurement base and the individual features can be 
> re-applied again, one by one, with measurement and analysis becoming a 
> lot easier.
> 

Ordinarily I would agree with you but would prefer a shorter window for
that type of strategy.

> > > Also it appears the Ebizzy numbers ought to be stable enough now 
> > > to make the range-TLB-flush measurements more precise?
> > 
> > Right now, the tlbflush microbenchmark figures look awful on the 
> > 8-core machine when the tlbflush shift patch and the schedule domain 
> > fix are both applied.
> 
> I think that furthr strengthens the case for the 'clean base' approach 
> I outlined above - but it's your call obviously ...
> 

I'll keep it as plan b if it cannot be fixed with a direct approach.

> Thanks again for going through all this. Tracking multi-commit 
> performance regressions across 1.5 years worth of commits is generally 
> very hard. Does your testing effort comes from enterprise Linux QA 
> testing, or did you ran into this problem accidentally?
> 

It does not come from enterprise Linux QA testing but it's motivated by
it. I want to catch as many "obvious" performance bugs before they do as
it saves time and stress in the long run. To assist that, I setup continual
performance regression testing and ebizzy was included in the first report
I opened.  It makes me worry what the rest of the reports contain.

-- 
Mel Gorman
SUSE Labs
