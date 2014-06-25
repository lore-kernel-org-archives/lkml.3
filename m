Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaFYJhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:37:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:57378 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaFYJhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:37:11 -0400
Date: Wed, 25 Jun 2014 11:36:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH 2/6] irq_work: Implement remote queueing
Message-ID: <20140625093657.GN19860@laptop.programming.kicks-ass.net>
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
 <1402413309-3415-3-git-send-email-fweisbec@gmail.com>
 <53A9E0A5.5040402@wwwdotorg.org>
 <20140625051234.GD6758@twins.programming.kicks-ass.net>
 <20140625051721.GG3588@twins.programming.kicks-ass.net>
 <53AA6E11.1000404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AA6E11.1000404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 12:07:05PM +0530, Srivatsa S. Bhat wrote:
> I don't think irqs_disabled() is the problematic condition, since
> hotplug_cfg() invokes irq_work_run() from CPU_DYING context (which has
> irqs disabled). I guess you meant to remove the in_irq() check inside
> irq_work_run() instead?

Yes, clearly I should not get up at 6am.. :-) Let me go do a new one.
