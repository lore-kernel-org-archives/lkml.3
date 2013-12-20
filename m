Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422680Ab3LTOIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:08:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58371 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422647Ab3LTOIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:08:46 -0500
Date: Fri, 20 Dec 2013 15:08:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: dietmar.eggemann@arm.com
Cc: mingo@redhat.com, vincent.guittot@linaro.org, morten.rasmussen@arm.com,
        chris.redpath@arm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 8/8] sched: remove scheduler domain naming
Message-ID: <20131220140842.GW16438@laptop.programming.kicks-ass.net>
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
 <1386936688-29113-9-git-send-email-dietmar.eggemann@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386936688-29113-9-git-send-email-dietmar.eggemann@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:11:28PM +0000, dietmar.eggemann@arm.com wrote:
> From: Dietmar Eggemann <dietmar.eggemann@arm.com>
> 
> In case the arch is allowed to define the conventional scheduler domain
> topology level (i.e. the one without SD_NUMA topology flag) layout, it is
> not feasible any more for the scheduler to name these levels.  Therefore,
> this patch gets rid of of the sched_domain_topology_level structure
> member 'name' and the corresponding SD_INIT_NAME macro.  It was only used
> when CONFIG_SCHED_DEBUG was set any way.

Right, so for debug purposes it might be convenient to keep it; we could
simply put it in the topology array, something like:

 { cpu_smt_mask, SD_SHARE_CPU_POWER | SD_SHARE_PKG_RESOURCE, SD_NAME(smt) },

which would still allow us to make it go away on !debug, but does
provide us with a nice label to print for the debug topology prints.

Alternatively we could do something like:

#define SD_mask(name, flags) \
	{ cpu_##name##_mask, (flags), .name = #name }

to further reduce typing.
