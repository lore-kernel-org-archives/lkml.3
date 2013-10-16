Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906Ab3JPWGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:06:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38885 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759149Ab3JPWGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:06:19 -0400
Date: Thu, 17 Oct 2013 00:06:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ben Segall <bsegall@google.com>
Cc: mingo@redhat.com, pjt@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] sched: Avoid throttle_cfs_rq racing with
 period_timer stopping
Message-ID: <20131016220609.GN10651@twins.programming.kicks-ass.net>
References: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
 <20131016181632.22647.84174.stgit@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016181632.22647.84174.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 11:16:32AM -0700, Ben Segall wrote:
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	SEQ_printf(m, "  .%-30s: %d\n", "tg->cfs_bandwidth.timer_active",
> +			cfs_rq->tg->cfs_bandwidth.timer_active);
> +	SEQ_printf(m, "  .%-30s: %d\n", "throttled",
> +			cfs_rq->throttled);
> +	SEQ_printf(m, "  .%-30s: %d\n", "throttle_count",
> +			cfs_rq->throttle_count);
> +#endif

Not really your fault; but that function just cries for something like:

#define SEQ_cfs_rq(m, member)		\
	SEQ_printf(m, "  .%-30s: %ld\n", #member, (long)cfs_rq->member)

