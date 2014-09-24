Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaIXSGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:06:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:42766 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaIXSGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:06:31 -0400
Date: Wed, 24 Sep 2014 20:06:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/20] arch atomic 'cleanup'
Message-ID: <20140924180623.GY6758@twins.programming.kicks-ass.net>
References: <20140508135840.956784204@infradead.org>
 <20140924165405.GJ16244@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924165405.GJ16244@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 05:54:06PM +0100, Will Deacon wrote:
> Hi Peter,
> 
> On Thu, May 08, 2014 at 02:58:40PM +0100, Peter Zijlstra wrote:
> > This series continues the arch atomic rework started with the smp_mb__
> > interface cleanup.
> > 
> > In this series we (mostly) reduce the atomic implementations by eliminating
> > repetition through use of CPP macros.
> > 
> > A future series will use these macros to implement more atomic ops. With these
> > macros we can end up with more atomic ops while the total LoC still shrinks.
> > 
> > Furthermore, rewrite the asm-generic/atomic implementations to require less and
> > provide more.
> > 
> > This series is compile tested on a number of archs, but only boot tested on
> > x86_64.
> 
> What's the status on this series? I'm currently fleshing out an extension to
> the atomic API that allows more flexible acquire/release semantics and it
> doesn't make sense for me to copy-paste a bunch of code when I could build
> it on top of this instead.

Its in tip/locking/arch and I suppose its headed for the next merge
window.

> Also, do you have any other patches pending in this area? I've lost track...

I do, I have (hopefully) one more series sweeping all archs introducing:
atomic_{or,and,xor,nand}() and then a few patches killing
atomic_{set,clear}_mask(). I just need to find time to write changelogs
and compile test them..

After that I need to go write that gcc-ll/sc proposal so we can pretend
to do generic composite atomic ops in C.

Oh, and like you pointed out, we need to do an audit of the barrier
semantics on some of our atomic functions like add_unless etc.

In other word, plenty to keep entertained.
