Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbaISPKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:10:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49434 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbaISPKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:10:11 -0400
Date: Fri, 19 Sep 2014 01:17:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 1/2] sched: let the scheduler see CPU idle states
Message-ID: <20140918231715.GO2848@worktop.localdomain>
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org>
 <1409844730-12273-2-git-send-email-nicolas.pitre@linaro.org>
 <20140918173733.GQ4723@linux.vnet.ibm.com>
 <alpine.LFD.2.11.1409181425080.8647@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1409181425080.8647@knanqh.ubzr>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 02:32:25PM -0400, Nicolas Pitre wrote:
> On Thu, 18 Sep 2014, Paul E. McKenney wrote:

> > So what is it that you really need to do here?
> 
> In short, we don't want the cpufreq data to go away (see the 2 scenarios 
> above) while the scheduler is looking at it.  The scheduler uses the 
> provided accessors (see patch 2/2) so we can put any protection 
> mechanism we want in them.  A simple spinlock could do just as well 
> which should be good enough.

rq->lock disables interrupts so on that something like
kick_all_cpus_sync() will guarantee what you need --
wake_up_all_idle_cpus() will not.
