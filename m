Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3LAVqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 16:46:13 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:48461 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3LAVqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 16:46:12 -0500
MIME-Version: 1.0
In-Reply-To: <1385930357.5352.44.camel@edumazet-glaptop2.roam.corp.google.com>
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
	<1385930357.5352.44.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Sun, 1 Dec 2013 13:46:11 -0800
X-Google-Sender-Auth: gydBnTPHnashxcab7iiHMsa-DOY
Message-ID: <CA+55aFynzPDA2Ccrh=dKHJ3U25HSi+RrYsCs2x_wt2xTKyzXpg@mail.gmail.com>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 1, 2013 at 12:39 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> Last time I checked, private futexes were used when appropriate.
>
> "strace -e futex" mainly show _PRIVATE uses.

Yeah, pthread mutexes seem to do it. Sadly we don't do it for
mm_release(), so the case of clear_child_tid doesn't trigger it, and
that happened to be what I tested (I did "git diff" with the threaded
pre-population of the stat data).  And we can't change that because
it's ABI. Sad.

So we do have a couple of corner cases where we *could* use the
private ones but don't. But I guess that thread creation/exit is
heavy-weight enough that that particular one doesn't really matter.

               Linus
