Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab3CROjs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:39:48 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43842 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3CROjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:39:47 -0400
Date: Sun, 17 Mar 2013 10:26:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
        Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
 atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive
	.patch added to -mm tree
Message-ID: <20130317172621.GQ3656@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130314162413.GA21344@redhat.com>
 <CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com>
 <20130315134632.GA18335@redhat.com>
 <CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com>
 <20130315165131.GA32065@redhat.com>
 <CAFTL4hxNh5qMZyyrLc8_yG5-i7UoS_nan22pO8o1fb8yS7Vz3w@mail.gmail.com>
 <20130315175117.GA2462@redhat.com>
 <CAFTL4hwZQcN_sO0SN8bJqEsQdC8ArDvJhFPg62Kh8OQyUe=MUw@mail.gmail.com>
 <20130315201739.GK3656@linux.vnet.ibm.com>
 <20130316183022.GB7560@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316183022.GB7560@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031814-4834-0000-0000-000004D559D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 07:30:22PM +0100, Oleg Nesterov wrote:
> On 03/15, Paul E. McKenney wrote:
> >
> > On Fri, Mar 15, 2013 at 07:34:32PM +0100, Frederic Weisbecker wrote:
> > > 2013/3/15 Oleg Nesterov <oleg@redhat.com>:
> > > >
> > > > My point was: should we fix atomic_add_unless() then? If not, why
> > > > should atomic_add_unless_negative() differ?
> > >
> > > They shouldn't differ I guess.
> >
> > Completely agreed.  It is not like memory ordering is simple, so we should
> > keep the rules simple.
> 
> It is hardly possible to argue with this ;)
> 
> > The rule is that if an atomic primitive returns non-void, then there is
> > a full memory barrier before and after.
> 
> This case is documented...
> 
> > This applies to primitives
> > returning boolean as well, with atomic_dec_and_test() setting this
> > precedent from what I can see.
> 
> I don't think this is the "fair" comparison. Unlike atomic_add_unless(),
> atomic_dec_and_test() always changes the memory even if it "fails".
> 
> If atomic_add_unless() returns 0, nothing was changed and if we add
> the barrier it is not clear what it should be paired with.
> 
> But OK. I have to agree that "keep the rules simple" makes sense, so
> we should change atomic_add_unless() as well.

Agreed!

							Thanx, Paul

