Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaGVQQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:16:23 -0400
Received: from one.firstfloor.org ([193.170.194.197]:48308 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776AbaGVQQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:16:20 -0400
Date: Tue, 22 Jul 2014 18:16:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@kernel.org,
        acme@infradead.org, eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH v3 5/9] perf, x86: large PEBS interrupt threshold
Message-ID: <20140722161617.GQ18735@two.firstfloor.org>
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com>
 <1406016602-31845-6-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406016602-31845-6-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/*
> +	 * When the event is constrained enough we can use a larger
> +	 * threshold and run the event with less frequent PMI.
> +	 */
> +	if (0 && /* disable this temporarily */

Where in the patchkit does it get reenabled?

-Andi

> +	    (hwc->flags & PERF_X86_EVENT_AUTO_RELOAD) &&
> +	    !(event->attr.sample_type & ~PEBS_FREERUNNING_FLAGS)) {
> +		threshold = ds->pebs_absolute_maximum -
> +			x86_pmu.max_pebs_events * x86_pmu.pebs_record_size;
> +	} else {
> +		threshold = ds->pebs_buffer_base + x86_pmu.pebs_record_size;
> +	}
> +	if (first_pebs || ds->pebs_interrupt_threshold > threshold)
> +		ds->pebs_interrupt_threshold = threshold;
