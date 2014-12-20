Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaLTBGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 20:06:32 -0500
Received: from www.linutronix.de ([62.245.132.108]:36387 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaLTBGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 20:06:31 -0500
Date: Sat, 20 Dec 2014 02:06:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Mason <clm@fb.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <1419034369.13012.8@mail.thefacebook.com>
Message-ID: <alpine.DEB.2.11.1412200201200.17382@nanos>
References: <20141218051327.GA31988@redhat.com> <1418918059.17358.6@mail.thefacebook.com> <20141218161230.GA6042@redhat.com> <20141219024549.GB1671@redhat.com> <CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com> <20141219035859.GA20022@redhat.com>
 <20141219040308.GB20022@redhat.com> <CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com> <20141219145528.GC13404@redhat.com> <CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com> <20141219203135.GA1200@ret.masoncoding.com>
 <alpine.DEB.2.11.1412200019210.17382@nanos> <1419034369.13012.8@mail.thefacebook.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014, Chris Mason wrote:
> On Fri, Dec 19, 2014 at 6:22 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > But at the very end this would be detected by the runtime check of the
> > hrtimer interrupt, which does not trigger. And it would trigger at
> > some point as ALL cpus including CPU0 in that trace dump make
> > progress.
> 
> I'll admit that at some point we should be hitting one of the WARN or BUG_ON,
> but it's possible to thread that needle and corrupt the timer list, without
> hitting a warning (CPU 1 in my example has to enqueue last).  Once the rbtree
> is hosed, it can go forever.  Probably not the bug we're looking for, but
> still suspect in general.

I surely have a close look at that, but in that case we get out of
that state later on and I doubt that we have 

     A) a corruption of the rbtree
     B) a self healing of the rbtree afterwards

I doubt it, but who knows.

Though even if A & B would happen we would still get the 'hrtimer
interrupt took a gazillion of seconds' warning because CPU0 definitely
leaves the timer interrupt at some point otherwise we would not see
backtraces from usb, userspace and idle later on.

Thanks,

	tglx




