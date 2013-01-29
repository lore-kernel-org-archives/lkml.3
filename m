Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3A2EDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:03:45 -0500
Received: from mout.gmx.net ([212.227.15.18]:63154 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab3A2EDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:03:42 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Em3Blqx1Ee2Npb1VRarCwrUW+fyF+Ak1daN2WTI
	H6B5/rKx8k71CC
Message-ID: <1359432213.5795.74.camel@marge.simpson.net>
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
Date: Tue, 29 Jan 2013 05:03:33 +0100
In-Reply-To: <510729B1.8070807@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com>
	 <510493E4.8060602@intel.com> <1359261385.5803.46.camel@marge.simpson.net>
	 <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com>
	 <1359301903.5805.11.camel@marge.simpson.net>
	 <1359350266.5783.39.camel@marge.simpson.net>
	 <1359388055.5783.164.camel@marge.simpson.net> <510729B1.8070807@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 09:45 +0800, Alex Shi wrote: 
> On 01/28/2013 11:47 PM, Mike Galbraith wrote:

> > monteverdi:/abuild/mike/:[0]# echo 1 > /sys/devices/system/cpu/cpufreq/boost
> > monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> > 014635  00058160
> > 014633  00058592
> > 014638  00058592
> > 014636  00058160
> > 014632  00058200
> > 014634  00058704
> > 014639  00058704
> > 014641  00058200
> > 014640  00058560
> > 014637  00058560
> > monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> > 014673  00059504
> > 014676  00059504
> > 014674  00059064
> > 014672  00059064
> > 014675  00058560
> > 014671  00058560
> > 014677  00059248
> > 014668  00058864
> > 014669  00059248
> > 014670  00058864
> > monteverdi:/abuild/mike/:[0]# massive_intr 10 60
> > 014686  00043472
> > 014689  00043472
> > 014685  00043760
> > 014690  00043760
> > 014687  00043528
> > 014688  00043528  (hmm)
> > 014683  00043216
> > 014692  00043208
> > 014684  00043336
> > 014691  00043336
> 
> I am sorry Mike. does above 3 times testing has a same sched policy? and
> same question for the following testing.

Yeah, they're back to back repeats.  Using dirt simple massive_intr
didn't help clarify aim7 oddity.

aim7 is fully repeatable, seems to be saying that consolidation of small
independent jobs is a win, that spreading before fully saturated has its
price, just as consolidation of large coordinated burst has its price.

Seems to cut both ways.. but why not, everything else does.

-Mike

