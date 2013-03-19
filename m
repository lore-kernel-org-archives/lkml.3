Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab3CSQ2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:28:36 -0400
Received: from longford.logfs.org ([213.229.74.203]:58735 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab3CSQ2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:28:35 -0400
Date: Tue, 19 Mar 2013 11:03:47 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH v4] target: close target_put_sess_cmd() vs.
 core_tmr_abort_task() race
Message-ID: <20130319150347.GA16558@logfs.org>
References: <20130319000411.GA6406@kroah.com>
 <20130318225657.GA9685@logfs.org>
 <20130319002742.GA11050@kroah.com>
 <20130318231154.GC9685@logfs.org>
 <20130318233413.GD9685@logfs.org>
 <20130319015354.GA21045@kroah.com>
 <20130319033112.GA11307@logfs.org>
 <20130319050954.GA23390@kroah.com>
 <20130319035803.GB11307@logfs.org>
 <20130319133852.GD24313@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130319133852.GD24313@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 March 2013 06:38:52 -0700, Greg Kroah-Hartman wrote:
> On Mon, Mar 18, 2013 at 11:58:03PM -0400, Jörn Engel wrote:
> > 
> > It compiles.  I don't have a good testcase, so the procedure is to
> > throw it into the test infrastructure and wait a week.
> 
> Really?  Please make a test cast to test it out properly.

So you are willing to reject a patch that clearly fixes a bug because
there is no testcase?  And given that the bug is a race, any testcase
will still boil down to "run this for as long as it took to reproduce
the problem, then triple the time".  I can reproduce the problem in
our test infrastructure maybe twice a week, so I could call that a
testcase just to provide you some formalistic argument to accept the
patch.

Of course the alternatives would be to stop using kref or to leave the
bug in.  I really wish I wouldn't have to contemplate either of those.

> > The alternative would be to call local_irq_restore(flags); from
> > kref_put_spinlock_irqsave() and not pass the flags.  Getting rid of
> > the extra parameter would be nice.  But I'm not sure I want to prove
> > that
> > 	spin_unlock(lock);
> > 	local_irq_restore(flags);
> > is the same as 
> > 	spin_unlock_irqrestore(lock, flags);
> > on all architectures and with all combinations of CONFIG options.
> 
> It should be.

We agree then.  I will change the patch and see how it behaves in our
setup.

Jörn

--
Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it.
-- Brian W. Kernighan
