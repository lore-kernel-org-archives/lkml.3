Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaJHIu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:50:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:46374 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbaJHIuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:50:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="396982640"
Date: Wed, 8 Oct 2014 08:50:07 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: peterz@infradead.org, mingo@redhat.com, dietmar.eggemann@arm.com,
        pjt@google.com, bsegall@google.com, vincent.guittot@linaro.org,
        nicolas.pitre@linaro.org, mturquette@linaro.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] sched: Introduce scale-invariant load tracking
Message-ID: <20141008005007.GA7017@intel.com>
References: <1411403047-32010-1-git-send-email-morten.rasmussen@arm.com>
 <1411403047-32010-2-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411403047-32010-2-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morten,

Sorry for late jumping in.

The problem seems to be self-evident. But for the implementation to be
equally attractive it needs to account for every freq change for every task,
or anything less than that makes it less attractive.

But this should be very hard. Intel Architecture has limitation to capture all
the freq changes in software and also the intel_pstate should have no
notification.

For every task, this makes the updating of the entire queue in load tracking
more needed, so once again, ping maintainers for the rewrite patches, :)

Thanks,
Yuyang

On Mon, Sep 22, 2014 at 05:24:01PM +0100, Morten Rasmussen wrote:
> From: Dietmar Eggemann <dietmar.eggemann@arm.com>
> 
> The per-entity load-tracking currently neither accounts for frequency
> changes due to frequency scaling (cpufreq) nor for micro-architectural
> differences between cpus (ARM big.LITTLE). Comparing tracked loads
> between different cpus might therefore be quite misleading.
> 
> This patch introduces a scale-invariance scaling factor to the
> load-tracking computation that can be used to compensate for compute
> capacity variations. The scaling factor is to be provided by the
> architecture through an arch specific function. It may be as simple as:
> 
> 	current_freq(cpu) * SCHED_CAPACITY_SCALE / max_freq(cpu)
> 
> If the architecture has more sophisticated ways of tracking compute
> capacity, it can do so in its implementation. By default, no scaling is
> applied.
> 
> The patch is loosely based on a patch by Chris Redpath
> <Chris.Redpath@arm.com>.
> 
> cc: Paul Turner <pjt@google.com>
> cc: Ben Segall <bsegall@google.com>
> 
> Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
