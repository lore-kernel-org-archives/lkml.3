Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3BVIdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:33:00 -0500
Received: from mout.gmx.net ([212.227.15.19]:54087 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab3BVIc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:32:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+OHK9iRdGOFMc1BhkV+JAGfLPpbAgiDBkrbMhELr
	RfO1u2lRNB546j
Message-ID: <1361521033.5817.95.camel@marge.simpson.net>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Fri, 22 Feb 2013 09:17:13 +0100
In-Reply-To: <5127135E.7030502@linux.vnet.ibm.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com>
	 <1361427108.5861.41.camel@marge.simpson.net>
	 <5125C607.8090909@linux.vnet.ibm.com>
	 <1361434231.5861.61.camel@marge.simpson.net>
	 <5125E40D.6050006@linux.vnet.ibm.com>
	 <1361439789.5861.70.camel@marge.simpson.net>
	 <5126D9A2.8090404@linux.vnet.ibm.com>
	 <1361509372.5817.60.camel@marge.simpson.net>
	 <5127135E.7030502@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 14:42 +0800, Michael Wang wrote:

> So this is trying to take care the condition when curr_cpu(local) and
> prev_cpu(remote) are on different nodes, which in the old world,
> wake_affine() won't be invoked, correct?

It'll be called any time this_cpu and prev_cpu aren't one and the same.
It'd be pretty silly to asking whether to pull_here or leave_there when
here and there are identical.

> Hmm...I think this maybe a good additional checking before enter balance
> path, but I could not estimate the cost to record the relationship at
> this moment of time...

It'd be pretty cheap, but I'd hate adding any cycles to the fast path
unless those cycles have one hell of a good payoff, so the caching would
have to show most excellent cold hard numbers (talk crazy ideas walk;).

-Mike

