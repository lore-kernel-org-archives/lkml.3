Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3ILUqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:46:23 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:47472 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3ILUqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:46:22 -0400
Date: Thu, 12 Sep 2013 22:46:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912204618.GA3262@gmail.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912201855.GC32644@gmail.com>
 <20130912203831.GD11400@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912203831.GD11400@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Thu, Sep 12, 2013 at 10:18:55PM +0200, Ingo Molnar escreveu:
> > * David Ahern <dsahern@gmail.com> wrote:
> > 
> > > On 9/12/13 11:43 AM, Arnaldo Carvalho de Melo wrote:
> > 
> > > > Its something that annoys me as well, but not so much as to make me 
> > > > figure out how to make those be done only if some source file changed.
> > > 
> > > Jiri and I have both taken stabs at a config-based build rather than 
> > > probing. Just need to finish it.
> > 
> > Mind outlining the approach you are thinking about?
> > 
> > Firstly, please don't even think about autotools. (Just forget it exists.)
> 
> hehe, no, that wasn't considered.

/phew! :-)

> > Secondly, the way perf tries to build by auto-detecting the build 
> > environment and auto-disabling bits it cannot build just yet is pretty 
> > powerful. The core bits will build on just about any system, and our 
> > fallbacks are really good.
> 
> That would remain as:
> 
> make -C tools/perf autoconfig
>  
> > The result is that perf will build on just about any random system, 
> > without the user having to install any dependency. It would be really 
> > sad to lose that aspect.
> 
> we will not

But it would be nice to keep building as simple as 'make'.

So I don't think splitting out the feature tests into a separate pass, to 
be done manually by the user, is a step forward.

Speeding them up by caching their results, while cleaning up the 
presentation of the testcases, on the other hand, would be a (big!) step 
forward.

Thanks,

	Ingo
