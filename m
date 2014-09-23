Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaIWOJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:09:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:33273 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaIWOJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:09:40 -0400
Date: Tue, 23 Sep 2014 16:09:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] x86: Use ACCESS_ONCE() for atomic_read()
Message-ID: <20140923140938.GF3312@worktop.programming.kicks-ass.net>
References: <1411415590-12193-1-git-send-email-bobby.prani@gmail.com>
 <20140922200716.GB3128@worktop.programming.kicks-ass.net>
 <CAJhHMCBx0_GTTHS66+2HGyJe-zcMR4d-O2x+xooNsPfvdHKd-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCBx0_GTTHS66+2HGyJe-zcMR4d-O2x+xooNsPfvdHKd-A@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 09:32:05AM -0400, Pranith Kumar wrote:
> On Mon, Sep 22, 2014 at 4:07 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, Sep 22, 2014 at 03:53:09PM -0400, Pranith Kumar wrote:
> >> Use the much easier to read ACCESS_ONCE() which is basically the same thing as
> >> the cast to volatile.
> >>
> >> Please note the change in volatile cast: ACCESS_ONCE(v)->counter to
> >> ACCESS_ONCE(v->counter).
> >>
> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> >> ---
> >>  arch/x86/include/asm/atomic.h | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > If you want to do something like so, then be consistent and do them all.
> 
> Hi Peter,
> 
> The changelog across all archs is as follows
> 
> 18 files changed, 24 insertions(+), 24 deletions(-)
> 
> Do you think it is better to send it as one patch or break up into
> patch for each arch?

I'd send it as a single patch, its small enough as is, and basically
just a 'style' update.
