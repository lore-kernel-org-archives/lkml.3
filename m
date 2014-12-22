Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaLVDMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 22:12:08 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:52556 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaLVDMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 22:12:05 -0500
Date: Sun, 21 Dec 2014 19:11:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@codemonkey.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141222031156.GU11609@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.11.1412200100130.17382@nanos>
 <CA+55aFxY5hCuGaK0JvTwHFsQKFGeh3_82ukKrU9ss4x4uHMY3Q@mail.gmail.com>
 <CA+55aFzj_2tYJ1b=_7eKSz7UMuUL+qZX39r0xq5vOZkB4JmHMA@mail.gmail.com>
 <CA+55aFyQzpQgT91sqpEhXho8KoVRkA1MeRjk+fXO7w2dJkY_Gg@mail.gmail.com>
 <CA+55aFy8DCMmkPRz0kqNC80pn4VkeQr2Wz2fTRm=32oH2dhfRQ@mail.gmail.com>
 <CA+55aFwA7uOFgb-Y4dHS099HuoV+oQvxXf+cfZYh9T7H_c0PHA@mail.gmail.com>
 <20141221223204.GA9618@codemonkey.org.uk>
 <CA+55aFygv+PRcYScwCjGVQ7-0PA1mHOGYaKGKS4LBhxPm0YBJA@mail.gmail.com>
 <CA+55aFwaghUQxp9LJRWH6ANCX5y45c3Fu9T0OnpBaqRdn1=tvw@mail.gmail.com>
 <CA+55aFzn2K-QJ00_ug6+3z4tdGQr_y3izRTxDpCA0qeW9cvsdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzn2K-QJ00_ug6+3z4tdGQr_y3izRTxDpCA0qeW9cvsdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122203-0021-0000-0000-000007278C79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 04:52:28PM -0800, Linus Torvalds wrote:
> On Sun, Dec 21, 2014 at 4:41 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > The second time (or third, or fourth - it might not take immediately)
> > you get a lockup or similar. Bad things happen.
> 
> I've only tested it twice now, but the first time I got a weird
> lockup-like thing (things *kind* of worked, but I could imagine that
> one CPU was stuck with a lock held, because things eventually ground
> to a screeching halt.
> 
> The second time I got
> 
>   INFO: rcu_sched self-detected stall on CPU { 5}  (t=84533 jiffies
> g=11971 c=11970 q=17)
> 
> and then
> 
>    INFO: rcu_sched detected stalls on CPUs/tasks: { 1 2 3 4 5 6 7}
> (detected by 0, t=291309 jiffies, g=12031, c=12030, q=57)
> 
> with backtraces that made no sense (because obviously no actual stall
> had taken place), and were the CPU's mostly being idle.

Yep, if time gets messed up too much, RCU can incorrectly decide that
21 seconds have elapsed since the grace period started, and can even
decide this pretty much immediately after the grace period starts.

							Thanx, Paul

> I could easily see it resulting in your softlockup scenario too.
> 
>                           Linus
> 

