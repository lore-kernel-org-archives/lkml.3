Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbaGWJW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:22:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:36145 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaGWJWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:22:02 -0400
Date: Wed, 23 Jul 2014 11:21:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, toshi.kani@hp.com,
        mingo@kernel.org, akpm@linux-foundation.org,
        todd.e.brandt@linux.intel.com, fabf@skynet.be,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] PM/CPU: Parallel enabling nonboot cpus with resume
 devices
Message-ID: <20140723092154.GH20603@laptop.programming.kicks-ass.net>
References: <1406106694-3306-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406106694-3306-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:11:34PM +0800, Lan Tianyu wrote:
> In the current world, all nonboot cpus are enabled serially during system
> resume. System resume sequence is that boot cpu enables nonboot cpu one by
> one and then resume devices. Before resuming devices, there are few tasks
> assigned to nonboot cpus after they are brought up. This waste cpu usage.
> 
> To accelerate S3, this patches adds a new kernel configure
> PM_PARALLEL_CPU_UP_FOR_SUSPEND to allow boot cpu to go forward to resume
> devices after bringing up one nonboot cpu. The nonboot cpu will be in charge
> of bringing up other cpus. This makes enabling cpu2~x parallel with resuming
> devices. From the test result on 4 logical core laptop, the time of resume
> device almost wasn't affected by enabling nonboot cpus lately while the start
> point is almost 30ms earlier than before.

Why is this a CONFIG and why do we want to add more warts to the cpu
hotplug instead of fixing it 'proper'?
