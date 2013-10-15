Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab3JOIbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 04:31:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:56521 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970Ab3JOIbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 04:31:17 -0400
Date: Tue, 15 Oct 2013 01:31:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: josh@freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] kernel/rcutorture.c: about using scnprintf()
 instead of sprintf().
Message-ID: <20131015083112.GH5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5253C335.5050609@asianux.com>
 <20131013110518.GC5790@linux.vnet.ibm.com>
 <525B4BB0.1090609@asianux.com>
 <525B555C.3040102@asianux.com>
 <20131014112457.GN5790@linux.vnet.ibm.com>
 <525C9D18.6040909@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525C9D18.6040909@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101508-9332-0000-0000-000001C4F529
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:40:40AM +0800, Chen Gang wrote:
> On 10/14/2013 07:24 PM, Paul E. McKenney wrote:
> > On Mon, Oct 14, 2013 at 10:22:20AM +0800, Chen Gang wrote:
> >>>  - intend to shrink maximized buffer (PAGE_SIZE -> 64, 256 ..) for test.
> > 
> > This is a good start!  However, you should also test the original kernel
> > to be sure that it really fails.  You should of course start by asking
> > yourself how you would expect it to fail.
> 
> When shrink size, for scnprintf() we already got truncation, that means
> if we still use sprintf(), it will cause memory overflow.
> 
> For memory overflow, it does not means OS will stop quickly, one of the
> worst condition is "it may still seems going 'well' but sometimes
> may/will show some amazing things which is not easy to find root cause".
> 
> So for this kind of memory overflow, "shrinking size and letting
> scnprintf() instead of sprintf() to see whether truncation" is well enough.
> 
> > What other change should you make to test this in order to be sure that
> > it will really work when someone tries it on 1024 CPUs?  (I am asking
> > rather than telling because you really need to have this stuff worked
> > out on your initial submission.)
> 
> Hmm... Can it really work on 1024 CPUs? sorry I don't know. But in fact,
> that is not about this patch (it is just one of case which may cause
> issues).
> 
> This patch is only about "use truncation instead of memory overflow, and
> make sure the modification without negative effect". So in my opinion,
> current test case is enough for this requirement.

Yes, the patch is about "use truncation instead of memory overflow",
but the truncation would also be a problem on large systems.  Is it
possible to prevent memory from overflow in the first place?

> Maybe you want to let this module get additional test to find additional
> issues? (If so, I will try when my time resource is possible).
> 
> > Another way of thinking about this is to ask yourself the question "If
> > someone ran rcutorture with torture_type=srcu on a system with 1024 CPUs
> > (to say nothing of 4096 CPUs), what would they want to happen?"  Then:
> > "How would I test for that on a smaller system?"
> 
> We have to face the efficiency: it is only a test module, if the tester
> (assume he/she is a programmer, too) notices about the truncation, they
> can simply extend the maximize length to avoid truncation.

True.  But you can make a change that is just as simple that allows you
to test what would happen on a 1024-CPU system even though your own
system has only 2 CPUs.  Can you see what that change is?

							Thanx, Paul

> At least for me, "rcutorture.c" is really easy enough for a programmer
> to test rcu (and also, it is really a useful tool for test rcu).
> 
> And for "1024 CPUs",  I think one of efficient way is: "when some
> members use it under 1024 CPUs, if they find something can be
> improvement, they can report/send related patch".
> 
> 
> Hmm... maybe the comment "it is ... additional test or consideration"
> need be removed: 'additional' and 'consideration' are not suitable words
> to be appeared in comments (they are not precise word).
> 
> 
> Thanks.
> -- 
> Chen Gang
> 

