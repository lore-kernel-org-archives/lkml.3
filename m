Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaGVAvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:51:10 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:37711 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaGVAvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:51:08 -0400
Date: Mon, 21 Jul 2014 20:51:04 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH percpu/for-3.17 2/2] blk-throttle: replace custom async
 percpu alloc mechanism with percpu_pool
Message-ID: <20140722005104.GI12921@htj.dyndns.org>
References: <20140718200804.GG13012@htj.dyndns.org>
 <20140718200834.GH13012@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718200834.GH13012@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 04:08:34PM -0400, Tejun Heo wrote:
> From 0a4bd997ba9725565883c688d7dcee8264abf71c Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Fri, 18 Jul 2014 16:07:14 -0400
> 
> throtl_pd_init() is called under the queue lock but needs to allocate
> the percpu stats area.  This is currently handled by queueing it on a
> list and scheduling a work item to allocate and fill the percpu stats
> area.  Now that perpcu_pool is available, this custom mechanism can be
> replaced.
> 
> Add tg_stats_cpu_pool and implement tg_ensure_stats_cpu() which tries
> to make sure that tg->stats_cpu is populated to replace the custom
> async alloc mechanism.  As percpu_pool allocation can fail,
> tg_ensure_stats_cpu() is invoked whenever ->stats_cpu is about to be
> accessed.  This is similar to the way code was structured before as
> the custom async alloc could take arbitrary amount of time and each
> access should verify that ->stats_cpu is populated.
> 
> This simplifies the code.  There shouldn't be noticeable functional
> difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>

Jens, can I route this patch through percpu tree?

Thanks.

-- 
tejun
