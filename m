Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab3A1Lk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:40:58 -0500
Received: from mout.gmx.net ([212.227.15.19]:63272 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986Ab3A1Lkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:40:55 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+AGGZ7c6GAWDNn0Kigql1bwv2mHm26+NqCa7a4eJ
	BGXTCxj2MMkjd4
Message-ID: <1359373246.5783.138.camel@marge.simpson.net>
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
From: Mike Galbraith <efault@gmx.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2013 12:40:46 +0100
In-Reply-To: <1359372743.5783.136.camel@marge.simpson.net>
References: <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com>
	 <510493E4.8060602@intel.com> <1359261385.5803.46.camel@marge.simpson.net>
	 <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com>
	 <1359301903.5805.11.camel@marge.simpson.net>
	 <1359350266.5783.39.camel@marge.simpson.net>
	 <20130128095501.GB6109@pd.tnic>
	 <1359369884.5783.117.camel@marge.simpson.net>
	 <20130128112922.GA29384@pd.tnic>
	 <1359372743.5783.136.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 12:32 +0100, Mike Galbraith wrote: 
> On Mon, 2013-01-28 at 12:29 +0100, Borislav Petkov wrote: 
> > On Mon, Jan 28, 2013 at 11:44:44AM +0100, Mike Galbraith wrote:
> > > On Mon, 2013-01-28 at 10:55 +0100, Borislav Petkov wrote: 
> > > > On Mon, Jan 28, 2013 at 06:17:46AM +0100, Mike Galbraith wrote:
> > > > > Zzzt.  Wish I could turn turbo thingy off.
> > > > 
> > > > Try setting /sys/devices/system/cpu/cpufreq/boost to 0.
> > > 
> > > How convenient (test) works too.
> > > 
> > > So much for turbo boost theory.  Nothing changed until I turned load
> > > balancing off at NODE.  High end went to hell (gee), but low end... 
> > >   
> > > Benchmark       Version Machine Run Date
> > > AIM Multiuser Benchmark - Suite VII     "1.1"   performance-no-node-load_balance Jan 28 11:20:12 2013
> > > 
> > > Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
> > > 1       436.3           100     13.9    3.9     7.2714
> > > 5       2637.1          99      11.5    7.3     8.7903
> > > 10      5415.5          99      11.2    11.3    9.0259
> > > 20      10603.7         99      11.4    24.8    8.8364
> > > 40      20066.2         99      12.1    40.5    8.3609
> > > 80      35079.6         99      13.8    75.5    7.3082
> > > 160     55884.7         98      17.3    145.6   5.8213
> > > 320     79345.3         98      24.4    287.4   4.1326
> > 
> > If you're talking about those results from earlier:
> > 
> > Benchmark       Version Machine Run Date
> > AIM Multiuser Benchmark - Suite VII     "1.1"   performance     Jan 28 08:09:20 2013
> > 
> > Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
> > 1       438.8           100     13.8    3.8     7.3135
> > 5       2634.8          99      11.5    7.2     8.7826
> > 10      5396.3          99      11.2    11.4    8.9938
> > 20      10725.7         99      11.3    24.0    8.9381
> > 40      20183.2         99      12.0    38.5    8.4097
> > 80      35620.9         99      13.6    71.4    7.4210
> > 160     57203.5         98      16.9    137.8   5.9587
> > 320     81995.8         98      23.7    271.3   4.2706
> > 
> > then the above no_node-load_balance thing suffers a small-ish dip at 320
> > tasks, yeah.
> 
> No no, that's not restricted to one node.  It's just overloaded because
> I turned balancing off at the NODE domain level.

Which shows only that I was multitasking, and in a rush.  Boy was that
dumb.  Hohum.

-Mike

