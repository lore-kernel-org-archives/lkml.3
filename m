Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaIBQIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:08:48 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48410 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaIBQIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:08:47 -0400
Date: Tue, 2 Sep 2014 09:08:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] doc: memory-barriers.txt: Correct example for reorderings
Message-ID: <20140902160841.GA5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1408972138-12246-1-git-send-email-bobby.prani@gmail.com>
 <53FF8B77.7000103@infradead.org>
 <20140828210010.GM5001@linux.vnet.ibm.com>
 <CAJhHMCDxsukXe_HW55iJp0oCAWgrosxCRX1AfocS6QBzxaD0pw@mail.gmail.com>
 <20140828213945.GP5001@linux.vnet.ibm.com>
 <CAJhHMCDaMH0b0Np8vNf=RBH8i76AUK78qf213aWfHY-F4j3OOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCDaMH0b0Np8vNf=RBH8i76AUK78qf213aWfHY-F4j3OOw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090216-8236-0000-0000-00000512853A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 05:45:10PM -0400, Pranith Kumar wrote:
> On Thu, Aug 28, 2014 at 5:39 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Aug 28, 2014 at 05:15:50PM -0400, Pranith Kumar wrote:
> >> On Thu, Aug 28, 2014 at 5:00 PM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> >
> >> > I am really confused by the ordering of the new lines, as I would have
> >> > expected the "x"s to be replaced with "y"s and vice versa.  But the
> >> > ordering of the various combinations does not matter, and each line
> >> > looks OK.
> >>
> >> Since x = A was replaced by x = B and y = B was replaced by y = A, I
> >> just converted all x = load A to x = load B. Similarly for y. I think
> >> we can do either this or as you suggested replacing x's with y's.
> >
> > Fair enough.  The other thing that confused me was the "STORE B=4,"
> > showing up early in your replacement.
> 
> So I converted
> 
> STORE A=3, x=LOAD A->3
> 
> to
> 
> STORE B=4, x=LOAD B->4
> 
> since the later load into x wanted an updated value of B and not the
> default. That is the reason you see STORE B = 4  in place of STORE A =
> 3

Fair enough.

However, the list is supposed to be part of the full set of 24 possible
outcomes.  Many readers would therefore expect the permutations to be
ordered in some way, so that the first column would have six of one thing,
six of the next thing, and so on, according to some pattern.

Could you please adjust in this way?  Again, the point is to be the
first few items in a full set of permutations, not to illustrate selected
orderings/outcomes.

							Thanx, Paul

