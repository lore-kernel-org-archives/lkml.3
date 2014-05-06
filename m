Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaEFPIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:08:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbaEFPIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:08:22 -0400
Message-ID: <1399388899.5192.273.camel@marge.simpson.net>
Subject: Re: Slow down stupid pounders
From: Mike Galbraith <mgalbraith@suse.de>
To: Borislav Petkov <bp@alien8.de>
Cc: lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 06 May 2014 17:08:19 +0200
In-Reply-To: <20140506102924.GA25013@pd.tnic>
References: <20140506102924.GA25013@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-06 at 12:29 +0200, Borislav Petkov wrote: 
> Hi,
> 
> so I'm getting sick'n'tired of all those bug reports of people pounding
> cpu hotplug with stupid scripts.
> 
> * We know cpu hotplug is fragile/buggy/crap/needs proper rewrite.
> 
> * Stupid hotplugging script doesn't resemble any real use case - go use
> a real benchmark/stress test to trigger bugs.
> 
> So if we can't make pounders stop jerking off, let's make it
> uninterestingly slow. Stupid patch below, it might be completely idiotic
> to do it this way but at least starts the discussion about this being a
> really annoying issue which needs some sort of dealing with.
> 
> I dunno, we can make it configurable (which will probably defeat its
> purpose partially), we can do some more fancy ratelimiting, per cpu,
> whatever... we'll see.
> 
> Opinions, flames?

Rather than ratelimit the interface perhaps send a ratelimited note
telling the user straight up that he's begging for trouble.  We can
ignore it when regression testing, and point it out to Joe Pounder
should he fail to notice.. or be somewhat dense.

-Mike

