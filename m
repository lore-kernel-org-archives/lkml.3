Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaILAHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 20:07:23 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58674 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaILAHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 20:07:22 -0400
Date: Thu, 11 Sep 2014 17:07:18 -0700
From: Darren Hart <dvhart@infradead.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Darren Hart <darren@dvhart.com>
Subject: Re: futex_wait_setup sleeping while atomic bug.
Message-ID: <20140912000718.GD18425@vmdeb7>
References: <20140911151040.GB3008@redhat.com>
 <alpine.DEB.2.10.1409112318500.4178@nanos>
 <1410479618.14217.4.camel@linux-t7sj.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410479618.14217.4.camel@linux-t7sj.site>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 04:53:38PM -0700, Davidlohr Bueso wrote:
> On Thu, 2014-09-11 at 23:52 +0200, Thomas Gleixner wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Thu, 11 Sep 2014 23:44:35 +0200
> > Subject: futex: Unlock hb->lock in futex_wait_requeue_pi() error path
> 
> That's the second time we are bitten by bugs in when requeing, now pi.
> We need to reconsider some of our testing tools to stress these paths
> better, imo.

We do, yes. Per the kselftest discussion at kernel summit, I agreed to move the
futextest testsuite into the kernel, function into kselftest and performance
into perf, then futextest can go away. From there we can look at how to improve
these tests.

Sadly, the best testing we seem to have is trinity - which does a fantastic job
at finding nasties.

If someone wanted to start having a look at migrating the futextest tests
over... I certainly wouldn't object to the help! ;-)

git://git.kernel.org/pub/scm/linux/kernel/git/dvhart/futextest.git

-- 
Darren Hart
Intel Open Source Technology Center
