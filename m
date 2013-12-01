Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3LAUjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 15:39:21 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36888 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3LAUjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 15:39:19 -0500
Message-ID: <1385930357.5352.44.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Jason Low <jason.low2@hp.com>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>, Scott Norton <scott.norton@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 01 Dec 2013 12:39:17 -0800
In-Reply-To: <CA+55aFz-v62jWpTqzAhrf5rGS5drbvgG-XHDDN6cdHCLB+kMxg@mail.gmail.com>
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
	 <CA+55aFz-v62jWpTqzAhrf5rGS5drbvgG-XHDDN6cdHCLB+kMxg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-01 at 10:58 -0800, Linus Torvalds wrote:

> Of course, I have no idea if people are properly using the private
> futexes. glibc _should_ use them, but who the heck knows..

Last time I checked, private futexes were used when appropriate.

"strace -e futex" mainly show _PRIVATE uses.

Example on "strace -f -e futex host www.google.com"



