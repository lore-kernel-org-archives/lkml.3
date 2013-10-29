Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab3J2UP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:15:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952Ab3J2UP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:15:28 -0400
Date: Tue, 29 Oct 2013 21:15:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131029201546.GA4932@redhat.com>
References: <20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com> <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com> <20131029102131.GA16117@laptop.programming.kicks-ass.net> <20131029103057.GN2490@laptop.programming.kicks-ass.net> <20131029103526.GO2490@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029103526.GO2490@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29, Peter Zijlstra wrote:
>
> On Tue, Oct 29, 2013 at 11:30:57AM +0100, Peter Zijlstra wrote:
> > @@ -154,9 +175,11 @@ int perf_output_begin(struct perf_output
> >  		 * Userspace could choose to issue a mb() before updating the
> >  		 * tail pointer. So that all reads will be completed before the
> >  		 * write is issued.
> > +		 *
> > +		 * See perf_output_put_handle().
> >  		 */
> >  		tail = ACCESS_ONCE(rb->user_page->data_tail);
> > -		smp_rmb();
> > +		smp_mb();
> >  		offset = head = local_read(&rb->head);
> >  		head += size;
> >  		if (unlikely(!perf_output_space(rb, tail, offset, head)))
>
> That said; it would be very nice to be able to remove this barrier. This
> is in every event write path :/

Yes.. And I'm afraid very much that I simply confused you. Perhaps Victor
is right and we do not need this mb(). So I am waiting for the end of
this story too.

And btw I do not understand why we need it (or smp_rmb) right after
ACCESS_ONCE(data_tail).

Oleg.

