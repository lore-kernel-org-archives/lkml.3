Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbaLOPWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:22:07 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55657 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaLOPWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:22:02 -0500
Date: Mon, 15 Dec 2014 16:21:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [PATCH 1/1] perf, x86: bug fix for cycles:p and cycles:pp on SLM
Message-ID: <20141215152150.GB29390@twins.programming.kicks-ass.net>
References: <1418048863-4294-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418048863-4294-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 06:27:43AM -0800, kan.liang@intel.com wrote:
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -568,8 +568,8 @@ struct event_constraint intel_atom_pebs_event_constraints[] = {
>  };
>  
>  struct event_constraint intel_slm_pebs_event_constraints[] = {
> -	/* UOPS_RETIRED.ALL, inv=1, cmask=16 (cycles:p). */
> -	INTEL_FLAGS_EVENT_CONSTRAINT(0x108001c2, 0xf),
> +	/* INST_RETIRED.ANY_P */
> +	INTEL_UEVENT_CONSTRAINT(0x00c0, 0x1),

Should that not be:
	INTEL_FLAGS_EVENT_CONSTRAINT(0x108000c0, 0x1),

instead?

>  	/* Allow all events as PEBS with no flags */
>  	INTEL_ALL_EVENT_CONSTRAINT(0, 0x1),
>  	EVENT_CONSTRAINT_END
> -- 
> 1.8.3.1
> 
