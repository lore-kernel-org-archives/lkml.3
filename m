Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3JJNKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:10:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38071 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab3JJNKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:10:51 -0400
Date: Thu, 10 Oct 2013 15:10:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH, -v2] compiler/gcc4: Add quirk for 'asm goto'
 miscompilation bug
Message-ID: <20131010131034.GN3081@twins.programming.kicks-ass.net>
References: <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <20131010084535.GA10620@gmail.com>
 <20131010085506.GA11775@gmail.com>
 <20131010115617.GY28601@twins.programming.kicks-ass.net>
 <20131010123236.GH30970@tucnak.zalov.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010123236.GH30970@tucnak.zalov.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 02:32:36PM +0200, Jakub Jelinek wrote:
> On Thu, Oct 10, 2013 at 01:56:17PM +0200, Peter Zijlstra wrote:
> > We didn't do version checks for CC_HAVE_ASM_GOTO because of vendor
> > backports; can't we detect this in the same way?
> 
> The problem is that it will be harder to check for this as compile time only
> check, and for runtime check you'd need to have the assembly string for
> every architecture and you couldn't do it for cross-compiling anyway.

> So for >= 4.8.3 just assume no
> workaround is needed, otherwise scan assembly.

Right, tedious and error prone it is.. :-)

Would it make sense to create something whereby GCC can tell us about
these things? Maybe something like:

  __builtin_bug_fixed(58670)

Which would default return 0, and only return 1 when its a known number.

But yes, I also see why you'd not want to do that. I suppose all I'm
saying is it would be nice to be able to detect some arbitrary issue
being fixed.

> See the follow-up mails, I think placing it immediately after asm goto might
> be better.

Duh indeed, must've missed that when I scanned through the thread :/
