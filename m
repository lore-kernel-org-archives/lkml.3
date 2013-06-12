Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab3FLUhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:37:17 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:38019 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab3FLUhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:37:14 -0400
MIME-Version: 1.0
In-Reply-To: <1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	<1370911480.9844.160.camel@gandalf.local.home>
	<CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
	<1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
	<1370974231.9844.212.camel@gandalf.local.home>
	<1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>
	<1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>
Date: Wed, 12 Jun 2013 13:37:12 -0700
X-Google-Sender-Auth: xcxeCQI9f5dCBguVDnxTiAdYNnE
Message-ID: <CA+55aFzJoxGH5J0yuBnWHcpxodymrKbySJ7v=vnfn9TSk7H5eA@mail.gmail.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Waiman Long <Waiman.Long@hp.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        =?UTF-8?B?6LWW5rGf5bGx?= <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 1:03 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
>
> Waiman's dcache patchet were actually an attempt to address these exact
> issues: http://lkml.org/lkml/2013/5/22/716

Ok, looking at that patch-set, I think it has the same race with not
atomically getting the d_lock spinlock and d_count going down to zero
in dput(). And Waiman clearly didn't know about
"atomic_inc_not_zero()" or "atomic_dec_and_lock()" that are designed
for exactly the "increment if already nonzero" and "decrement without
taking the lock if we're not going down to zero" cases.

As outlined, I'm also not at all sure that the whole seqrw-lock thing
that Waiman did is really necessary - I think the optimistic
dget_parent() might be sufficient.

                 Linus
