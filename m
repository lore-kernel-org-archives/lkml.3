Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712Ab3BYDXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 22:23:17 -0500
Received: from mout.gmx.net ([212.227.17.21]:55749 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757463Ab3BYDXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 22:23:16 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19eRyJ76aRehz4Ro99S1f3fwzOCvfPiDRjiT+MS66
	c5XUPV5kPkzg1w
Message-ID: <1361762585.4555.28.camel@marge.simpson.net>
Subject: Re: [patch v5 09/15] sched: add power aware scheduling in
 fork/exec/wake
From: Mike Galbraith <efault@gmx.de>
To: Alex Shi <alex.shi@intel.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Date: Mon, 25 Feb 2013 04:23:05 +0100
In-Reply-To: <512ACB39.1010605@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
	 <1361164062-20111-10-git-send-email-alex.shi@intel.com>
	 <1361353360.10155.9.camel@laptop> <5124BCEB.8030606@intel.com>
	 <1361367371.10155.32.camel@laptop> <5124DC76.2010801@intel.com>
	 <1361453587.26780.18.camel@laptop> <512631C7.8060103@intel.com>
	 <1361523279.26780.45.camel@laptop> <5129DD1A.8070509@intel.com>
	 <512A5332.6040507@linux.vnet.ibm.com> <512ACB39.1010605@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-25 at 10:23 +0800, Alex Shi wrote:

> One of problem is the how to decide the criteria of the burst? If we set
> 5 waking up/ms is burst, we will lose 4 waking up/ms.
> another problem is the burst detection cost, we need tracking a period
> history info of the waking up, better on whole group. but that give the
> extra cost in burst.
> 
> solution candidates:
> https://lkml.org/lkml/2013/1/21/316
> After talk with MikeG, I remove the runnable load avg in performance
> load balance.

One thing you could try is to make criteria depend on avg_idle.  It will
slam to 2*migration_cost when a wakeup arrives after an ~extended idle.
You could perhaps extend it to cover new task wakeup as well, and use
that transition to invalidate history, switch to instantaneous until
fresh history can accumulate.

-Mike

