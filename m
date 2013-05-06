Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab3EFJGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:06:50 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:52877 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3EFJGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:06:49 -0400
MIME-Version: 1.0
In-Reply-To: <51876AFE.80906@linux.vnet.ibm.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-8-git-send-email-alex.shi@intel.com> <518724D1.9040006@linux.vnet.ibm.com>
 <51874229.8050202@intel.com> <5187609C.5050209@linux.vnet.ibm.com>
 <518763B0.30200@intel.com> <51876AFE.80906@linux.vnet.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 6 May 2013 02:06:17 -0700
Message-ID: <CAPM31RK-N=Cnt3cBo1f6er6TewQJKY+fgdj9QHvKziHe+TxTxw@mail.gmail.com>
Subject: Re: [PATCH v5 7/7] sched: consider runnable load average in effective_load
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this is a good idea:

The problem with not using the instantaneous weight here is that you
potentially penalize the latency of interactive tasks (similarly,
potentially important background threads -- e.g. garbage collection).

Counter-intuitively we actually want such tasks on the least loaded
cpus to minimize their latency.  If the load they contribute ever
becomes more substantial we trust that periodic balance will start
taking notice of them.

[ This is similar to why we have to use the instantaneous weight in
calc_cfs_shares. ]
