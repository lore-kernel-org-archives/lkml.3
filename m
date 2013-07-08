Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3GHQsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:48:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38372 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab3GHQsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:48:08 -0400
Date: Mon, 8 Jul 2013 18:47:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: more ABI breakage
Message-ID: <20130708164721.GC22923@dyad.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1307081115350.2281@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1307081115350.2281@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 11:24:18AM -0400, Vince Weaver wrote:
> 
> I guess I should have been noisier about this at the time.
> 
> Linux 3.9 came with commit
>    e259514eef764a5286873618e34c560ecb6cff13
> that enabled AMD fam15h Northbridge support, by exposing the events as 
> part of the core CPU.
> 
> Then Linux 3.10 changed this with
>    c43ca5091a374c1f6778bd7e4a39a5a10735a917
> and split them out as a separate PMU.
> 
> This of course breaks libpfm4 and thus PAPI

Urgh, so the 3.9 patches should never have been merged and sunk in while I was
doing my vegetable imitation.

Stephane agreed with the change in 3.10; and I suppose he overlooked the fact
that people were already using it :/ I specifically asked if there were already
users as that would indeed require some form of backwards compatibility --
however annoying.

But to answer your question, no we should not blindly break stuff like this --
but yeah it would have been ever so much more useful for people to report this
before we ship a release.

Stephane; do you see a sane way to bridge this now?

