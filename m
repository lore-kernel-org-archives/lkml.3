Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158AbaLQRDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:03:37 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47220 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaLQRDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:03:36 -0500
Date: Wed, 17 Dec 2014 12:01:39 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141217170139.GB8142@laptop.dumpdata.com>
References: <alpine.DEB.2.11.1411212110320.6439@nanos>
 <CA+55aFyt6q7Ed-SS9GeN8jeUZu6yNM14EGyH_8rn8AF2Vv37hg@mail.gmail.com>
 <alpine.DEB.2.11.1411212207150.6439@nanos>
 <CA+55aFyzg=vJqRwh2CsK8WD-E5nRPjdiasMaTBx6qygQhDrGLA@mail.gmail.com>
 <20141216192803.GC3337@twins.programming.kicks-ass.net>
 <CA+55aFx9oTQHnamJ=QEGOKHe2obQEn2NfNa+hJ_Z-V1FyY7QaQ@mail.gmail.com>
 <20141216211921.GA2395@suse.de>
 <20141216230246.GA30905@twins.programming.kicks-ass.net>
 <CA+55aFxyx_wcsgYJC2GXcjEvMsTg=K=uy6A=xDJdWdvZsE1VHQ@mail.gmail.com>
 <CALCETrVLrXOZNY6Xha+TukJMTb2ni70FN==rL8KHM6FrMwWzVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVLrXOZNY6Xha+TukJMTb2ni70FN==rL8KHM6FrMwWzVQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 04:41:16PM -0800, Andy Lutomirski wrote:
> On Tue, Dec 16, 2014 at 4:00 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Tue, Dec 16, 2014 at 3:02 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >> OK, should we just stick it in the x86 tree and see if anything
> >> explodes? ;-)
> >
> > Gaah, I got confused about the patches.
> >
> > And something did explode, it showed some Xen nasties. Xen has that
> > odd "we don't share PMD entries between MM's" thing going on, which
> > means that the vmalloc fault thing does actually have to occasionally
> > walk two levels rather than just copy the top level. I'm still not
> > sure why Xen doesn't share PMD's, since threads that shame the MM
> > clearly can share PMD's within Xen, but I gave up on it.
> 
> Sounds like it's time to ask Konrad, the source of all Xen understanding :)

Awesome :-)
> 
> Linus, do you have a pointer to whatever version of the patch you tried?

The patch was this:

a) http://article.gmane.org/gmane.linux.kernel/1835331

Then Jurgen had a patch:
https://lkml.kernel.org/g/CA+55aFxSRujj=cM1NkXYvxmo=Y1hb1e3tgLhdh1JDphzV6WKRw@mail.gmail.com
which was one fix for one bug that ended up being fixed in QEMU - so
it can be ignored.

But my understanding of that thread was that it said patch 'a)' did not
fix Dave's issues - and the conversation went off on NMI watchdog?

I will look up the giant thread to make sense.


> 
> --Andy
> 
> >
> > That said, making x86-64 use "read_cr3()" instead of
> > "current->active_mm" would at least make things a bit safer wrt NMI's
> > during the task switch, of course.  So *some* 32/64-bit consolidation
> > should be done, but my patch went a bit too far for Xen.
> >
> >                       Linus
> 
> 
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC
