Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaB1M30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:29:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54753 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaB1M3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:29:25 -0500
Date: Fri, 28 Feb 2014 13:29:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Leach <matthew.leach@arm.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: A question regarding TG load tracking functions in fair.c
Message-ID: <20140228122922.GG9987@twins.programming.kicks-ass.net>
References: <87d2i7mojg.fsf@e106496-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2i7mojg.fsf@e106496-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 12:04:19PM +0000, Matthew Leach wrote:
> Hi Paul,
> 
> I have a question regarding two lines of code in the functions
> __update_cfs_rq_tg_load_contrib and __update_tg_runnable_avg. AFAICS
> these functions update a load-tracking signal for the local RQ and an
> aggregated signal in the TG for all RQs that belong to this TG. The
> update is surrounded by conditions:
> 
>   if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {
> 
> for __update_tg_runnable_avg and
> 
>   if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
> 
> for __update_cfs_rq_tg_load_contrib. Is this an optimisation to prevent
> the signals being updated for small variations? Also, could you please
> shed some light on the specific numbers used?

Yes, its an optimization; updating global state is expensive. I'll let
Paul explain the specific numbers.
