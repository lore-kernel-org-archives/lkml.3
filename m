Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab3A1Gtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 01:49:53 -0500
Received: from mout.gmx.net ([212.227.17.20]:63092 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab3A1Gtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 01:49:50 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/fxgN420Xf1hj5W3Qh20Rb71Tf/rexUPw/4pPz2x
	YU1X5PFVyRFF8s
Message-ID: <1359355782.5783.59.camel@marge.simpson.net>
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
From: Mike Galbraith <efault@gmx.de>
To: Alex Shi <alex.shi@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2013 07:49:42 +0100
In-Reply-To: <51060A6D.4090208@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com>
	 <510493E4.8060602@intel.com> <20130127104039.GC8894@pd.tnic>
	 <51060A6D.4090208@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 13:19 +0800, Alex Shi wrote: 
> On 01/27/2013 06:40 PM, Borislav Petkov wrote:
> > On Sun, Jan 27, 2013 at 10:41:40AM +0800, Alex Shi wrote:
> >> Just rerun some benchmarks: kbuild, specjbb2005, oltp, tbench, aim9,
> >> hackbench, fileio-cfq of sysbench, dbench, aiostress, multhreads
> >> loopback netperf. on my core2, nhm, wsm, snb, platforms. no clear
> >> performance change found.
> > 
> > Ok, good, You could put that in one of the commit messages so that it is
> > there and people know that this patchset doesn't cause perf regressions
> > with the bunch of benchmarks.
> > 
> >> I also tested balance policy/powersaving policy with above benchmark,
> >> found, the specjbb2005 drop much 30~50% on both of policy whenever
> >> with openjdk or jrockit. and hackbench drops a lots with powersaving
> >> policy on snb 4 sockets platforms. others has no clear change.
> > 
> > I guess this is expected because there has to be some performance hit
> > when saving power...
> > 
> 
> BTW, I had tested the v3 version based on sched numa -- on tip/master.
> The specjbb just has about 5~7% dropping on balance/powersaving policy.
> The power scheduling done after the numa scheduling logical.

That makes sense.  How the numa scheduling numbers compare to mainline?
Do you have all three available, mainline, and tip w. w/o powersaving
policy?

-Mike


