Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3LAS62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 13:58:28 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:60821 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3LAS60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 13:58:26 -0500
MIME-Version: 1.0
In-Reply-To: <20131201165538.GA12864@gmail.com>
References: <20131125203358.156292370@linutronix.de>
	<1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>
	<20131126085256.GD789@laptop.programming.kicks-ass.net>
	<1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>
	<1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
	<alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de>
	<1385624678.22210.25.camel@buesod1.americas.hpqcorp.net>
	<20131128115946.GD13532@twins.programming.kicks-ass.net>
	<20131201121022.GB12115@gmail.com>
	<20131201125604.GH16796@laptop.programming.kicks-ass.net>
	<20131201165538.GA12864@gmail.com>
Date: Sun, 1 Dec 2013 10:58:25 -0800
X-Google-Sender-Auth: V4GOPUp3OI9nHTpNMsGourThiR4
Message-ID: <CA+55aFz-v62jWpTqzAhrf5rGS5drbvgG-XHDDN6cdHCLB+kMxg@mail.gmail.com>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Jason Low <jason.low2@hp.com>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>, Scott Norton <scott.norton@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 1, 2013 at 8:55 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Keeping the page invariant would bring significant performance
> advantages to hashing.

Or not. Rather, it would make things much worse. The virtual address
is much simpler and better to avoid needing any page table lookup etc
crap. The key is just the mm and the virtual address, and no silly
page table walks etc necessary.

Of course, I have no idea if people are properly using the private
futexes. glibc _should_ use them, but who the heck knows..

                Linus
