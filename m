Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab3JNLZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:25:05 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53484 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab3JNLZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:25:02 -0400
Date: Mon, 14 Oct 2013 04:24:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] kernel/rcutorture.c: about using scnprintf()
 instead of sprintf().
Message-ID: <20131014112457.GN5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5253C335.5050609@asianux.com>
 <20131013110518.GC5790@linux.vnet.ibm.com>
 <525B4BB0.1090609@asianux.com>
 <525B555C.3040102@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525B555C.3040102@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101411-8236-0000-0000-000002B28B7C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 10:22:20AM +0800, Chen Gang wrote:
> On 10/14/2013 09:41 AM, Chen Gang wrote:
> > On 10/13/2013 07:05 PM, Paul E. McKenney wrote:
> >> On Tue, Oct 08, 2013 at 04:32:53PM +0800, Chen Gang wrote:
> >>> Hello Maintainers:
> >>>
> >>> In srcu_torture_stats(), if cpus are more than 1K, the PAGE_SIZE will
> >>> not be enough.
> >>>
> >>> In rcu_torture_printk(), the 'page' maximized size is 4096, it has a
> >>> function pointer for printing, which not tell its maximized length.
> >>>
> >>> Welcome any additional suggestions or completions.
> >>
> >> I never have run rcutorture on a system with that many CPUs.  ;-)
> > 
> > I guess most of members (include me), never have run under that case.

Indeed, there are not yet very many people with systems that large.

> >> Given that rcutorture is not used in production, my approach would be to
> >> fix this when I encountered it.  But what change would you suggest, and,
> >> more importantly, how would you go about testing it before submitting
> >> a patch?
> >>
> > 
> > OK, thanks, I will/should give a fix and test.
> > 
> > Hmm, In my opinion, we need:
> > 
> >  - let it pass LTP common simple test (so I can know how to test it).
> > 
> 
> Oh, after read "Documentation/RCU/torture.txt", it is a test module, so
> except related special test (e.g. shrink maximized buffer), it seems not
> need additional common test for it (e.g. LTP).

Yep!

> >  - intend to shrink maximized buffer (PAGE_SIZE -> 64, 256 ..) for test.

This is a good start!  However, you should also test the original kernel
to be sure that it really fails.  You should of course start by asking
yourself how you would expect it to fail.

What other change should you make to test this in order to be sure that
it will really work when someone tries it on 1024 CPUs?  (I am asking
rather than telling because you really need to have this stuff worked
out on your initial submission.)

Another way of thinking about this is to ask yourself the question "If
someone ran rcutorture with torture_type=srcu on a system with 1024 CPUs
(to say nothing of 4096 CPUs), what would they want to happen?"  Then:
"How would I test for that on a smaller system?"

> >  - read your original mail again (about testing contents) as reference.
> > 
> > Excuse me, I have to do some other things of company, so I will/should
> > try to finish it within this week (2013-10-20), if this time point is
> > not quite suitable, please let me know, thanks.
> > 
> >> Or if you are simply reporting this as a bug, please let me know that.
> > 
> > I will/should do: in q4 of 2013, I will/should spend part of my time
> > resources on testing.

OK, sounds good.

> > Welcome any additional suggestions or completions.

Please see above.

							Thanx, Paul

> > Thanks.
> > 
> 
> 
> -- 
> Chen Gang
> 

