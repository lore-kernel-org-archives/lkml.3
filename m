Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaBRA2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:28:06 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:44383 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaBRA2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:28:04 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 17 Feb 2014 16:27:44 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, linux@horizon.com
Subject: Re: [PATCH tip/core/rcu 15/55] rcutorture: Abstract
 rcu_torture_random()
Message-ID: <20140218002743.GF19929@thin>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392675179-11560-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140218001137.GC19929@thin>
 <20140218002248.GU4250@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218002248.GU4250@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 04:22:48PM -0800, Paul E. McKenney wrote:
> On Mon, Feb 17, 2014 at 04:11:37PM -0800, Josh Triplett wrote:
> > On Mon, Feb 17, 2014 at 02:12:19PM -0800, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > Because rcu_torture_random() will be used by the locking equivalent to
> > > rcutorture, pull it out into its own module.
> > > 
> > > Suggested-by: Rusty Russell <rusty@rustcorp.com.au>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > I'd suggest making CONFIG_TORTURE_TEST a completely invisible option,
> > with no description; it should only be brought in via "select".
> > 
> > Also, it doesn't need most of the headers it currently includes.
> > 
> > Have you considered moving it into the existing random generation
> > infrastructure, as something like "fast_insecure_nonblocking_random"?
> > That seems more generally useful.
> 
> George Spelvin was also advising me on random-number generation in
> rcutorture, so I added him on CC.  In any case, I would not be adverse
> to using some other random-number service, as long as it is fast enough.
> (George suggested some optimizations that I have not yet tried out.)

I suspect the fastest way to find out about any existing generator with
the desired properties would be to post this one as a patch to the
random number infrastructure and read the resulting replies. :)

- Josh Triplett
