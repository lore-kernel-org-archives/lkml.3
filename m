Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaBKIpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:45:11 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:48585 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaBKIpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:45:07 -0500
Date: Tue, 11 Feb 2014 09:45:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Jason Low <jason.low2@hp.com>, Waiman Long <waiman.long@hp.com>,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 0/8] locking/core patches
Message-ID: <20140211084502.GA26063@gmail.com>
References: <20140210195820.834693028@infradead.org>
 <20140210150230.b7f46688093ebc5c45fee870@linux-foundation.org>
 <20140211071700.GH27965@twins.programming.kicks-ass.net>
 <20140211000330.d791513d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211000330.d791513d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 11 Feb 2014 08:17:00 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, Feb 10, 2014 at 03:02:30PM -0800, Andrew Morton wrote:
> > > On Mon, 10 Feb 2014 20:58:20 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > I would propose merging the following patches...
> > > > 
> > > > The first set is mostly from Jason and tweaks the mutex adaptive
> > > > spinning, AIM7 throughput numbers:
> > > > 
> > 
> >                          Jobs/min/ Jobs/sec/ Time:   Time:  Time:   Time:           Running child time
> >          Forks  Jobs/min   child    child parent  childU childS  std_dev   JTI   :max  :min
> > 
> > > > PRE:  100   2000.04  21564.90 2721.29 311.99     3.12       0.01     0.00     99
> > > > POST: 100   2000.04  42603.85 5142.80 311.99     3.12       0.00     0.00     99
> > > 
> > > What do these columns represent?  I'm guessing the large improvement
> > > was in context switches?
> > 
> > I pasted the header from reaim above;
> 
> hmpf.  I wonder what's the difference between Jobs/min, Jobs/min(child)
> and Jobs/sec(child), which is not Jobs/min(child) / 60.
> 
> > I'm not entirely sure what the bloody thing does and I hate that 
> > it takes hours to get these numbers :/
> >
> > Bloody stupid benchmark if you ask me.
> 
> heh, yes, it's stupid how long many benchmarks take.  Ditch it.  A 
> change like this should be testable with a 30-line microbenchmark 
> which runs in 5 seconds tops.

Another very nice option would be to stick the relevant workload 
patterns into 'perf bench', calibrate it to emit similar figures (and 
double check the speedup is similar as well) and thus make it an AIM7 
work-alike microbenchmark.

Thanks,

	Ingo
