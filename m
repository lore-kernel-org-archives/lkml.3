Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3ILUnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:43:19 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:56702 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab3ILUnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:43:17 -0400
Date: Thu, 12 Sep 2013 22:43:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912204313.GA3259@gmail.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912203116.GD32644@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Instead of having 20 testcases crammed into a single Makefile:
> 
> comet:~/tip/tools/perf> git grep -w main config/feature-tests.mak 
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(int argc, char *argv[])
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> config/feature-tests.mak:int main(void)
> 
> Why not put those into 20x standalone .c files and try to build them as 
> an explicit make command attempt from within the main Makefile? If the 
> build fails then the feature flag is set to off, if it succeeds it's 
> defined.
> 
> That makes feature tests generally easier to debug, easier to understand 
> and generally easier to extend as well.
> 
> 'Feature test binaries' that are already built will be 'cached' 
> automatically, and the result of their build attempt will be a quick 
> success.

A successfull 'make' attempt of a target file within a separate, simple 
Makefile is very, very fast:

 comet:~/tip/tools/power/x86/turbostat> perf stat --null --sync --repeat 10 
 make turbostat
 make: `turbostat' is up to date.
 make: `turbostat' is up to date.
 make: `turbostat' is up to date.
 make: `turbostat' is up to date.
 make: `turbostat' is up to date.
 make: `turbostat' is up to date.
 make: `turbostat' is up to date.
 make: `turbostat' is up to date.
 make: `turbostat' is up to date.
 make: `turbostat' is up to date.

  Performance counter stats for 'make turbostat' (10 runs):

        0.002146182 seconds time elapsed                                          ( +-  0.35% )

That's 2 msecs only. 20 such tests will take less than 50 msecs in the 
'cached' case.

Thanks,

	Ingo

