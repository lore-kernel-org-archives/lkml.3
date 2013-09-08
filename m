Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3IHK7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 06:59:40 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38909 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3IHK7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 06:59:39 -0400
Date: Sun, 8 Sep 2013 12:59:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched next] overflowed cpu time for kernel threads in
 /proc/PID/stat
Message-ID: <20130908105932.GE4501@somewhere>
References: <20130820111426.GA27828@swordfish.datadirectnet.com>
 <20130820151509.GA17441@somewhere>
 <20130820153549.GB2315@swordfish.minsk.epam.com>
 <20130820154257.GD17441@somewhere>
 <20130821153957.GA2969@swordfish.minsk.epam.com>
 <20130830230402.GA14760@somewhere>
 <20130831190117.GA2213@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130831190117.GA2213@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 10:01:17PM +0300, Sergey Senozhatsky wrote:
> On (08/31/13 01:04), Frederic Weisbecker wrote:
> > But stime should always be below rtime due to the calculation done by scale_stime()
> > which roughly sums up to:
> > 
> >       stime = (stime / stime + utime) * rtime
> > 
> > So this shouldn't happen.
> > 
> > I couldn't manage to reproduce it though. Can you still trigger it with latest -next?
> > 
> > Thanks.
> 
> Hello,
> I can't pull current -next (away from good network connection for a
> couple of days). What I have is 3.11.0-rc7-next-20130829:
> 
> ps aux | grep rcu
> root         8  0.0  0.0      0     0 ?        S    Aug30   0:00 [rcuc/0]
> root         9  0.0  0.0      0     0 ?        S    Aug30   0:00 [rcub/0]
> root        10 21376376  0.0  0     0 ?        S    Aug30 21114581:36 [rcu_preempt]
> root        11 21376376  0.0  0     0 ?        S    Aug30 21114581:35 [rcuop/0]
> root        12 21376376  0.0  0     0 ?        S    Aug30 21114581:35 [rcuop/1]
> 
> cat /proc/10/stat
> 10 (rcu_preempt) S 2 0 0 0 -1 2129984 0 0 0 0 1844674407370 715 0 0 20 0 1 0 10 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744073709551615 0 0 17 0 0 0 0 0 0 0 0 0 0 0 0 0 0
> 
> 	-ss

Sorry, I did not realize this message was posted before you tested the patch.
