Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaJUO44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:56:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaJUO4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:56:55 -0400
Date: Tue, 21 Oct 2014 16:56:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [RESEND PATCH 2/3 v5] sched: Rewrite per entity runnable load
 average tracking
Message-ID: <20141021145652.GB23531@worktop.programming.kicks-ass.net>
References: <1412907717-2871-1-git-send-email-yuyang.du@intel.com>
 <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 10:21:56AM +0800, Yuyang Du wrote:
>  static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
>  {
> -	long tg_weight;
> -
> -	/*
> -	 * Use this CPU's actual weight instead of the last load_contribution
> -	 * to gain a more accurate current total weight. See
> -	 * update_cfs_rq_load_contribution().
> -	 */
> -	tg_weight = atomic_long_read(&tg->load_avg);
> -	tg_weight -= cfs_rq->tg_load_contrib;
> -	tg_weight += cfs_rq->load.weight;
> -
> -	return tg_weight;
> +	return atomic_long_read(&tg->load_avg);

Since you're now also delaying updating load_avg, why not retain this
slightly better approximation?
