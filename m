Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3BORp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:45:56 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:52443 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3BORpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:45:54 -0500
Date: Fri, 15 Feb 2013 09:44:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130215174435.GA2792@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130212193901.GA18906@redhat.com>
 <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
 <20130213004059.GA14451@redhat.com>
 <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
 <20130213041629.GA28622@redhat.com>
 <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com>
 <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
 <20130215011503.GA11914@redhat.com>
 <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyVE0jyu9uw659ERw5E2DdOhwkQp3gk=gcXP0xrmMh9qA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021517-5518-0000-0000-00000BA1016E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 06:09:44PM -0800, Linus Torvalds wrote:
> On Thu, Feb 14, 2013 at 5:15 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > Given I never saw this on a Fedora kernel, just my self-built ones, I eventually
> > gave up on bisecting code, and switched to bisecting config options.
> > I should have started this way, as I figured it out within an hour.
> >
> > 3.7 merge window is when I started seeing this, and here's what got introduced
> > during that time..
> >
> > commit e3ebfb96f396731ca2d0b108785d5da31b53ab00
> > Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > Date:   Mon Jul 2 14:42:01 2012 -0700
> >
> >     rcu: Add PROVE_RCU_DELAY to provoke difficult races
> >
> > 'difficult' is an understatement.  This explains why some of those 'good'
> > bisects survived 100 suspends on one day, and failed the next.
> >
> > Unfortunatly, I don't think there's any sane way to retrieve whatever debug
> > info might be getting spewed.
> 
> Hmm. I have to say, that's a particularly unhelpful config option. It
> may make races much easier to hit, but when you do hit them, what's
> the symptoms of said race?
> 
> Paul? Apparently you end up with a dead machine at least during resume
> and no oops. Which isn't very helpful. Maybe there is possibly some
> BUG_ON() in the RCU code somewhere?
> 
> So Paul, if you know what the common symptoms of the bug that that
> debug option helps trigger are, is there some way to make them less
> lethal and still print out useful information?

This commit was designed to increase the probability of hitting the
races described in http://lwn.net/Articles/453002/.  These races result
in deadlocks involving the runqueue lock (and perhaps also the priority
inheritance locks).  And yes, I most certainly should have described
this in the commit message.  :-(

So it looks like Dave is hitting some other race/bug than the one that
this commit was designed to expose.

I must confess that I don't know how to proceed without any meaningful
debug information here.  Feel free to revert the above commit if you would
like -- I can of course always maintain it locally for my own testing.

							Thanx, Paul

