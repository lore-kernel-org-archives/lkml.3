Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaETJM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:12:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaETJM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:12:27 -0400
Date: Tue, 20 May 2014 11:12:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/3] perf: disable sampled events if no PMU interrupt
Message-ID: <20140520091216.GS2485@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1405161701160.11099@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405161708060.11099@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405161708060.11099@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 05:12:12PM -0400, Vince Weaver wrote:
> 
> Add common code to generate ENOTSUPP at event creation time if an 
> architecture attempts to create a sampled event and PERF_PMU_NO_INTERRUPT
> is set.
> 
> This adds a new pmu->capabilities flag.  
> Initially we only support PERF_PMU_NO_INTERRUPT (to indicate a PMU
> has no support for generating hardware interrupts) but there are 
> other capabilities that can be added later.
> 
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 3356abc..2164763 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -251,9 +251,20 @@ struct pmu {
>  	 * flush branch stack on context-switches (needed in cpu-wide mode)
>  	 */
>  	void (*flush_branch_stack)	(void);
> +
> +	/*
> +	 * various common per-pmu feature flags
> +	 */
> +	int capabilities;

As suggested by Will, I've put it in a 4 byte hole earlier in the
structure.

>  };
>  
>  /**
> + * struct pmu->capabilites flags

Due to braindamage from years of C++ coding, many other comments refer
to members using the C++ :: notation, so I've changed that to be
consistent and read: pmu::capabilities.

> + */
> +#define PERF_PMU_NO_INTERRUPT		1

Are you ok with me making that:

#define PERF_PMU_CAP_NO_INTERRUPT		0x01


