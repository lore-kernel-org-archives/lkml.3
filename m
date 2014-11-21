Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbaKUMdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:33:43 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36530 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaKUMdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:33:42 -0500
Date: Fri, 21 Nov 2014 12:34:31 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v9 00/10] sched: consolidation of CPU capacity and usage
Message-ID: <20141121123430.GA23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:54:37PM +0000, Vincent Guittot wrote:
> This patchset consolidates several changes in the capacity and the usage
> tracking of the CPU. It provides a frequency invariant metric of the usage of
> CPUs and generally improves the accuracy of load/usage tracking in the
> scheduler. The frequency invariant metric is the foundation required for the
> consolidation of cpufreq and implementation of a fully invariant load tracking.
> These are currently WIP and require several changes to the load balancer
> (including how it will use and interprets load and capacity metrics) and
> extensive validation. The frequency invariance is done with
> arch_scale_freq_capacity and this patchset doesn't provide the backends of
> the function which are architecture dependent.
> 
> As discussed at LPC14, Morten and I have consolidated our changes into a single
> patchset to make it easier to review and merge.
> 
> During load balance, the scheduler evaluates the number of tasks that a group
> of CPUs can handle. The current method assumes that tasks have a fix load of
> SCHED_LOAD_SCALE and CPUs have a default capacity of SCHED_CAPACITY_SCALE.
> This assumption generates wrong decision by creating ghost cores or by
> removing real ones when the original capacity of CPUs is different from the
> default SCHED_CAPACITY_SCALE. With this patch set, we don't try anymore to
> evaluate the number of available cores based on the group_capacity but instead
> we evaluate the usage of a group and compare it with its capacity.
> 
> This patchset mainly replaces the old capacity_factor method by a new one and
> keeps the general policy almost unchanged. These new metrics will be also used
> in later patches.
> 
> The CPU usage is based on a running time tracking version of the current
> implementation of the load average tracking. I also have a version that is
> based on the new implementation proposal [1] but I haven't provide the patches
> and results as [1] is still under review. I can provide change above [1] to
> change how CPU usage is computed and to adapt to new mecanism.
> 
> Change since V8
>  - reorder patches

I think the patch set is in a good shape. I have got few comments and
suggestions mostly minor things and things related to naming to the
first 7 patches. I haven't found any problems with the code itself. I
haven't tested it yet though. The last three patches I have a few
questions for.

Morten
