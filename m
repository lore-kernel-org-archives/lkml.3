Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998AbaLLDE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 22:04:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964939AbaLLDEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 22:04:23 -0500
Date: Thu, 11 Dec 2014 22:03:43 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141212030343.GA7945@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com>
 <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 01:49:17PM -0800, Linus Torvalds wrote:
 
 > Anyway, you might as well stop bisecting. Regardless of where it lands
 > in the remaining pile, it's not going to give us any useful
 > information, methinks.
 > 
 > I'm stumped.

yeah, likewise.  I don't recall any bug that's given me this much headache.
I don't think it's helped that the symptoms are vague enough that a
number of people have thought they've seen the same thing, which have
turned out to be unrelated incidents.  At least some of those have
gotten closure though it seems.

 > Maybe it's worth it to concentrate on just testing current kernels,
 > and instead try to limit the triggering some other way. In particular,
 > you had a trinity run that was *only* testing lsetxattr(). Is that
 > really *all* that was going on? Obviously trinity will be using
 > timers, fork, and other things? Can you recreate that lsetxattr thing,
 > and just try to get as many problem reports as possible from one
 > particular kernel (say, 3.18, since that should be a reasonable modern
 > base with hopefully not a lot of other random issues)?

I'll let it run overnight, but so far after 4hrs, on .18 it's not done
anything.

 > Together with perhaps config checks. You've done some those already.
 > Did it reproduce without preemption, for example?

Next kernel build I try, I'll turn that off.  I don't remember if
we've already tried that.  I *think* we just tried the non-preempt rcu
stuff, but not "no preemption at all".  I wish I'd kept better notes
about everything tried so far too, but I hadn't anticipated this
dragging out so long. Live and learn..

	Dave

