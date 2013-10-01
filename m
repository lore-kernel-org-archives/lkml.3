Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab3JAImx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:42:53 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:61794 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab3JAImv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:42:51 -0400
Date: Tue, 1 Oct 2013 10:42:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20131001084247.GE21793@gmail.com>
References: <20130928180327.GA5000@gmail.com>
 <20130929114700.GB282@x4>
 <20130929213329.GA2125@tassilo.jf.intel.com>
 <20130930062735.GA13482@gmail.com>
 <20130930185428.GE2125@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930185428.GE2125@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> > > Hmm, works for me. In fact I wrote it to fix a perf top issue.
> >
> > What 'issue' and why wasn't it described in the changelog more 
> > accurately?
> >
> > The blurb you wrote in the changelog:
> > 
> > | The libbfd C++ demangler doesn't seem to deal with cloned functions, 
> > | like symbol.clone.NUM.
> > |
> > | Just strip the dot part before demangling and add it back later.
> > 
> > Only alludes to a C++ symbol resolution annoyance and thus isn't very 
> > informative.
> 
> The issue was that I saw a long unreadable line noise string in 
> report/top, instead of a demangled function. After I stripped the 
> postfix I got the demangled symbol as expected.

We obviously don't want to trade output annoyances for crashes, nor does 
it justify the code uglies you introduced with the patch - which made the 
code obviously unrobust.

My guess would be that maybe it's the cast of a const pointer that 
possibly broke GCC's aliasing detection on Markus's system or so. But 
maybe there's a more direct bug in the code as well, the code you added is 
too ugly to be reviewed efficiently, please send a cleaned up version.

Thanks,

	Ingo
