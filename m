Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3A0Pv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 10:51:57 -0500
Received: from mout.gmx.net ([212.227.15.19]:50197 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab3A0Pvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 10:51:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ZZfJU10kZedX67vcu+HBDzMH4Y2Oki65cpPZ66K
	N5gz5dUU0Di14P
Message-ID: <1359301903.5805.11.camel@marge.simpson.net>
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
Date: Sun, 27 Jan 2013 16:51:43 +0100
In-Reply-To: <51052ACB.3070703@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <20130124094439.GB13463@pd.tnic> <51014E34.60309@intel.com>
	 <510493E4.8060602@intel.com> <1359261385.5803.46.camel@marge.simpson.net>
	 <20130127103508.GB8894@pd.tnic> <51052ACB.3070703@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-27 at 21:25 +0800, Alex Shi wrote: 
> On 01/27/2013 06:35 PM, Borislav Petkov wrote:
> > On Sun, Jan 27, 2013 at 05:36:25AM +0100, Mike Galbraith wrote:
> >> With aim7 compute on 4 node 40 core box, I see stable throughput
> >> improvement at tasks = nr_cores and below w. balance and powersaving. 
... 
> > Ok, this is sick. How is balance and powersaving better than perf? Both
> > have much more jobs per minute than perf; is that because we do pack
> > much more tasks per cpu with balance and powersaving?
> 
> Maybe it is due to the lazy balancing on balance/powersaving. You can
> check the CS times in /proc/pid/status.

Well, it's not wakeup path, limiting entry frequency per waker did zip
squat nada to any policy throughput.

-Mike

