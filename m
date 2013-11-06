Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab3KFPy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:54:57 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44502 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3KFPy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:54:56 -0500
Date: Wed, 6 Nov 2013 10:54:45 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
Message-ID: <20131106155445.GB6357@neilslaptop.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
 <20131106153429.GA26336@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106153429.GA26336@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 10:34:29AM -0500, Dave Jones wrote:
> On Wed, Nov 06, 2013 at 10:23:19AM -0500, Neil Horman wrote:
>  > do_csum was identified via perf recently as a hot spot when doing
>  > receive on ip over infiniband workloads.  After alot of testing and
>  > ideas, we found the best optimization available to us currently is to
>  > prefetch the entire data buffer prior to doing the checksum
>  > 
>  > diff --git a/arch/x86/lib/csum-partial_64.c b/arch/x86/lib/csum-partial_64.c
>  > index 9845371..9f2d3ee 100644
>  > --- a/arch/x86/lib/csum-partial_64.c
>  > +++ b/arch/x86/lib/csum-partial_64.c
>  > @@ -29,8 +29,15 @@ static inline unsigned short from32to16(unsigned a)
>  >   * Things tried and found to not make it faster:
>  >   * Manual Prefetching
>  >   * Unrolling to an 128 bytes inner loop.
>  > - * Using interleaving with more registers to break the carry chains.
>  
> Did you mean perhaps to remove the "Manual Prefetching" line instead ?
> (Curious, what was tried before that made it not worthwhile?)
>  
Crap, I didn't notice that previously, thanks Dave.

My guess was that the whole comment was made in reference to the fact that
checksum offload negated all these advantages.  Thats not so true anymore, since
infiniband needs csum in software for ipoib.

I'll fix this up and send a v3, but I'll give it a day in case there are more
comments first.

Thanks
Neil

> 	Dave
>  
> 
