Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3FKAXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 20:23:08 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51978 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3FKAXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 20:23:05 -0400
Date: Mon, 10 Jun 2013 17:22:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130611002258.GY5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370905376.9844.137.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370905376.9844.137.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061100-2876-0000-0000-000009B5E991
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 07:02:56PM -0400, Steven Rostedt wrote:
> On Sun, 2013-06-09 at 12:36 -0700, Paul E. McKenney wrote:
> 
> > +/*
> > + * Return a pointer to the queue header associated with the specified lock,
> > + * or return NULL if there is no queue for the lock or if the lock's queue
> > + * is in transition.
> > + */
> > +static struct tkt_q_head *tkt_q_find_head(arch_spinlock_t *asp)
> 
> BTW, what does "asp" mean? arch_spinlock?

"arch_spinlock pointer", but yes.  Or I suppose a millenia-late warning
to Cleopatra.

>                                            If so, can we just call it
> "lock" and be consistent with all the other spinlock calls in the
> kernel. Because, I keep thinking this has something to do with Microsoft
> dynamic web pages.

Fair enough!

							Thanx, Paul

> -- Steve
> 
> > +{
> > +	int i;
> > +	int start;
> > +
> > +	start = i = tkt_q_hash(asp);
> > +	do
> > +		if (tkt_q_heads[i].ref == asp)
> > +			return &tkt_q_heads[i];
> > +	while ((i = tkt_q_next_slot(i)) != start);
> > +	return NULL;
> > +}
> > +
> 
> 

