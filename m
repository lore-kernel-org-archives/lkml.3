Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3LCSAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:00:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:33360 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab3LCSAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:00:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,819,1378882800"; 
   d="scan'208";a="446158733"
Message-ID: <1386093564.5377.55.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
From: Darren Hart <dvhart@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Jason Low <jason.low2@hp.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 03 Dec 2013 09:59:24 -0800
In-Reply-To: <CA+55aFynzPDA2Ccrh=dKHJ3U25HSi+RrYsCs2x_wt2xTKyzXpg@mail.gmail.com>
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
	 <CA+55aFynzPDA2Ccrh=dKHJ3U25HSi+RrYsCs2x_wt2xTKyzXpg@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-01 at 13:46 -0800, Linus Torvalds wrote:
> On Sun, Dec 1, 2013 at 12:39 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > Last time I checked, private futexes were used when appropriate.
> >
> > "strace -e futex" mainly show _PRIVATE uses.
> 
> Yeah, pthread mutexes seem to do it.

Yes, the default was changed to _PRIVATE for pthreads in glibc several
years back (2007 iirc). The performance benefits were significant.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


