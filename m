Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161552Ab3DKIoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:44:39 -0400
Received: from mout.gmx.net ([212.227.15.18]:49897 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab3DKIoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:44:37 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX184MS5pRPE4hVAbrsOBUd94uOJabMMk6V+fUjEkJl
	ViEJaDWj231NSh
Message-ID: <1365669862.19620.129.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: wake-affine throttle
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Thu, 11 Apr 2013 10:44:22 +0200
In-Reply-To: <516673BF.4080404@linux.vnet.ibm.com>
References: <5164DCE7.8080906@linux.vnet.ibm.com>
	 <1365583873.30071.31.camel@laptop> <51652F43.7000300@linux.vnet.ibm.com>
	 <516651C8.307@linux.vnet.ibm.com>
	 <1365665447.19620.102.camel@marge.simpson.net>
	 <516673BF.4080404@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 16:26 +0800, Michael Wang wrote:

> The 1:N is a good reason to explain why the chance that wakee's hot data
> cached on curr_cpu is lower, and since it's just 'lower' not 'extinct',
> after the throttle interval large enough, it will be balanced, this
> could be proved, since during my test, when the interval become too big,
> the improvement start to drop.

Magnitude of improvement drops just because there's less damage done
methinks.  You'll eventually run out of measurable damage :)

Yes, it's not really extinct, you _can_ reap a gain, it's just not at
all likely to work out.  A more symetric load will fare better, but any
1:N thing just has to spread far and wide to have any chance to perform.
> Hmm...that's an interesting point, the workload contain different
> 'priority' works, and depend on each other, if mother starving, all the
> kids could do nothing but wait for her, may be that's the reason why the
> benefit is so significant, since in such case, mother's little quicker
> respond will make all the kids happy :)

Exactly.  The entire load is server latency bound.  Keep the server on
cpu, the load performs as best it can given unavoidable data miss cost.

-Mike

