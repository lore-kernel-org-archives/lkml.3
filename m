Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaAUO4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:56:33 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:55089 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbaAUO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:56:18 -0500
Date: Tue, 21 Jan 2014 15:56:15 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Cong Ding <dinggnu@gmail.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140121145615.GA4697@gmail.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
 <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
 <CA+55aFyaf2B4Fo-dCJUJ=03aPVdLF7r4uMYNduYPMFwJQYngcA@mail.gmail.com>
 <52DDAD9D.9030504@zytor.com>
 <20140121090003.GO31570@twins.programming.kicks-ass.net>
 <52DE8231.6080408@zytor.com>
 <20140121143939.GA4643@gmail.com>
 <52DE8989.1010208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DE8989.1010208@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> > The thing is, one of my first remarks on this whole KASLR series 
> > was that tooling needs to work. I suggested that the kernel should 
> > only expose non-randomized addresses and that all facilities need 
> > to continue to 'just work' with those. That argument was ignored 
> > AFAICS and the problem still isn't solved.
> > 
> > I'd argue that solving it in the kernel instead of making all 
> > tooling variants aware of KASLR one by one is a far more 
> > intelligent and efficient solution ...
> 
> Not ignored, but found not to really work all that well (we had that 
> discussion in the context of relocated kernels, too.)  The problem 
> you end up with is that as soon as you run into situations where you 
> have to deal with pointers during debugging, be it using kgdb, stack 
> dumps or whatever, all the work that you have done in the kernel to 
> try to hide relocation from the debug infrastructure all of a sudden 
> becomes a huge liability, and ends up backfiring in a horrific way.

The thing is, that 'huge liability' is now pushed into tooling, which 
isn't in any better position to judge a piece of data in a backtrace 
than the kernel - in fact it's in an arguably worse position, as it 
does not generate that data.

kgdb is an entirely different animal, I'm talking about the 99% 
usecase: code profiling and tooling interpreting code addresses that 
come from the kernel.

Thanks,

	Ingo
