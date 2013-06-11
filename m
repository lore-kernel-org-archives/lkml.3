Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab3FKAvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 20:51:17 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:41250 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab3FKAvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 20:51:15 -0400
MIME-Version: 1.0
In-Reply-To: <1370911480.9844.160.camel@gandalf.local.home>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	<1370911480.9844.160.camel@gandalf.local.home>
Date: Mon, 10 Jun 2013 17:51:14 -0700
X-Google-Sender-Auth: LpTFC28MN2kPcJXjOy3Cb_5f-No
Message-ID: <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
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
        sbw@mit.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 5:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> OK, I haven't found a issue here yet, but youss are beiing trickssy! We
> don't like trickssy, and we must find precccciouss!!!

.. and I personally have my usual reservations. I absolutely hate
papering over scalability issues, and historically whenever people
have ever thought that we want complex spinlocks, the problem has
always been that the locking sucks.

So reinforced by previous events, I really feel that code that needs
this kind of spinlock is broken and needs to be fixed, rather than
actually introduce tricky spinlocks.

So in order to merge something like this, I want (a) numbers for real
loads and (b) explanations for why the spinlock users cannot be fixed.

Because "we might hit loads" is just not good enough. I would counter
with "hiding problems causes more of them".

               Linus
