Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab3GRJ0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:26:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58016 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab3GRJ0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:26:40 -0400
Date: Thu, 18 Jul 2013 11:26:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH 2/2] perf, x86: Add Silvermont (22nm Atom) support
Message-ID: <20130718092627.GG27075@twins.programming.kicks-ass.net>
References: <1374138144-17278-1-git-send-email-zheng.z.yan@intel.com>
 <1374138144-17278-2-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374138144-17278-2-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 05:02:24PM +0800, Yan, Zheng wrote:
> +static struct event_constraint intel_slm_event_constraints[] __read_mostly =
> +{
> +	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
> +	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
> +	FIXED_EVENT_CONSTRAINT(0x013c, 2), /* CPU_CLK_UNHALTED.REF */
> +	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* pseudo CPU_CLK_UNHALTED.REF */
> +	EVENT_CONSTRAINT_END
> +};

I'm still missing the fixup for intel_pmu_init() that will make this
actually work -- and the comment to clarify that yes slm really does
count them the same.
