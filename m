Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab3IPLE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:04:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47667 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3IPLE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:04:58 -0400
Date: Mon, 16 Sep 2013 13:04:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, acme@infradead.org, linux-kernel@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/6] perf, core: Add generic transaction flags v4
Message-ID: <20130916110447.GS21832@twins.programming.kicks-ass.net>
References: <1379095716-4705-1-git-send-email-andi@firstfloor.org>
 <1379095716-4705-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379095716-4705-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 11:08:31AM -0700, Andi Kleen wrote:
>  /*
> + * Values for the transaction event qualifier, mostly for abort events.
> + * Multiple bits can be set.
> + */
> +enum {
> +	PERF_SAMPLE_TXN_ELISION        = (1 << 0), /* From elision */
> +	PERF_SAMPLE_TXN_TRANSACTION    = (1 << 1), /* From transaction */
> +	PERF_SAMPLE_TXN_SYNC           = (1 << 2), /* Instruction is related */
> +	PERF_SAMPLE_TXN_ASYNC          = (1 << 3), /* Instruction not related */
> +	PERF_SAMPLE_TXN_RETRY          = (1 << 4), /* Retry possible */
> +	PERF_SAMPLE_TXN_CONFLICT       = (1 << 5), /* Conflict abort */
> +	PERF_SAMPLE_TXN_CAPACITY_WRITE = (1 << 6), /* Capacity write abort */
> +	PERF_SAMPLE_TXN_CAPACITY_READ  = (1 << 7), /* Capacity read abort */
> +
> +	PERF_SAMPLE_TXN_MAX	       = (1 << 8),  /* non-ABI */
> +
> +	/* bits 24..31 are reserved for the abort code */
> +
> +	PERF_SAMPLE_TXN_ABORT_MASK  = 0xff000000,
> +	PERF_SAMPLE_TXN_ABORT_SHIFT = 24,
> +};

Also do we want to do s/_SAMPLE// on that? Sadly we have both patterns,
PERF_SAMPLE_BRANCH_xxx and PERF_MEM_xxx.


