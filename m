Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab3LUF5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 00:57:17 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:14632 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3LUF5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 00:57:16 -0500
Message-ID: <1387605430.3119.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 20 Dec 2013 21:57:10 -0800
In-Reply-To: <CA+55aFwj_zWyUb8w3nqoWbmRXcHSsuYD2BrJ+aD8x7A0Sg6ZXw@mail.gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
	 <1387567810.2704.19.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFwj_zWyUb8w3nqoWbmRXcHSsuYD2BrJ+aD8x7A0Sg6ZXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-20 at 11:54 -0800, Linus Torvalds wrote:
> On Fri, Dec 20, 2013 at 11:30 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >
> > So we'd need the barrier right after the ticket increment (ie: the xadd
> > TICKET_LOCK_INC in x86), and cannot rely on the barrier after the lock
> > is taken as we could miss waiters that are just spinning trying to take
> > it. Is this implicitly guaranteed across all archs?
> 
> Not necessarily. But I don't see why threads spinning on it would be
> special? If you spin on things, you've already updated the head
> counter, so even spinners *are* visible, even if they haven't actually
> gotten the lock yet.

Fair enough, just making sure we're covering all cases.

