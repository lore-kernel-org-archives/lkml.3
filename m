Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab3ILUim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:38:42 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:45540 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab3ILUih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:38:37 -0400
Date: Thu, 12 Sep 2013 17:38:31 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912203831.GD11400@ghostprotocols.net>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912201855.GC32644@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912201855.GC32644@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 12, 2013 at 10:18:55PM +0200, Ingo Molnar escreveu:
> * David Ahern <dsahern@gmail.com> wrote:
> 
> > On 9/12/13 11:43 AM, Arnaldo Carvalho de Melo wrote:
> 
> > > Its something that annoys me as well, but not so much as to make me 
> > > figure out how to make those be done only if some source file changed.
> > 
> > Jiri and I have both taken stabs at a config-based build rather than 
> > probing. Just need to finish it.
> 
> Mind outlining the approach you are thinking about?
> 
> Firstly, please don't even think about autotools. (Just forget it exists.)

hehe, no, that wasn't considered.
 
> Secondly, the way perf tries to build by auto-detecting the build 
> environment and auto-disabling bits it cannot build just yet is pretty 
> powerful. The core bits will build on just about any system, and our 
> fallbacks are really good.

That would remain as:

make -C tools/perf autoconfig
 
> The result is that perf will build on just about any random system, 
> without the user having to install any dependency. It would be really sad 
> to lose that aspect.

we will not

> What I think would work best is what I outlined in the previous mail: to 
> cache successful feature test results and only re-do unsuccessful tests: 
> those are the ones that are expected to turn into successful tests in the 
> future, once the missing dependencies are installed.

that is an optimization to 'make autoconfig', i.e. what we have now,
improved.
 
> Since most tests succeed even on a sparsely installed system, this trick 
> alone will speed up the checks big time.
> 
> Furthermore, this method would encourage people to install the 
> dependencies - and perf developers, who do many repeat builds after 
> trivial one-file changes, will typically have all dependencies installed 
> anyway, so for them such a caching feature would result in totally cached 
> feature tests and very fast build times.

What he mentioned is the multiple attempts at doing:

make -C tools/perf menuconfig

and use kbuild to allow one to select what he/she wants to build, i.e.
using the kernel config system in perf.

In that case the feature checks would be triggered only for the features
selected, not for all perf currently selectable features.

- Arnaldo
