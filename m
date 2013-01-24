Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3AXJlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:41:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37654 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab3AXJls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:41:48 -0500
Date: Thu, 24 Jan 2013 10:44:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
Message-ID: <20130124094439.GB13463@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
	mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
	akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
	namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
	gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
	viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 11:06:42AM +0800, Alex Shi wrote:
> Since the runnable info needs 345ms to accumulate, balancing
> doesn't do well for many tasks burst waking. After talking with Mike
> Galbraith, we are agree to just use runnable avg in power friendly 
> scheduling and keep current instant load in performance scheduling for 
> low latency.
> 
> So the biggest change in this version is removing runnable load avg in
> balance and just using runnable data in power balance.
> 
> The patchset bases on Linus' tree, includes 3 parts,
> ** 1, bug fix and fork/wake balancing clean up. patch 1~5,
> ----------------------
> the first patch remove one domain level. patch 2~5 simplified fork/wake
> balancing, it can increase 10+% hackbench performance on our 4 sockets
> SNB EP machine.

Ok, I see some benchmarking results here and there in the commit
messages but since this is touching the scheduler, you probably would
need to make sure it doesn't introduce performance regressions vs
mainline with a comprehensive set of benchmarks.

And, AFAICR, mainline does by default the 'performance' scheme by
spreading out tasks to idle cores, so have you tried comparing vanilla
mainline to your patchset in the 'performance' setting so that you can
make sure there are no problems there? And not only hackbench or a
microbenchmark but aim9 (I saw that in a commit message somewhere) and
whatever else multithreaded benchmark you can get your hands on.

Also, you might want to run it on other machines too, not only SNB :-)
And what about ARM, maybe someone there can run your patchset too?

So, it would be cool to see comprehensive results from all those runs
and see what the numbers say.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
