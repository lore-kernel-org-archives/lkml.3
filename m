Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763502Ab3EDAyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 20:54:05 -0400
Received: from mail-gh0-f169.google.com ([209.85.160.169]:45787 "EHLO
	mail-gh0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab3EDAyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 20:54:04 -0400
Date: Fri, 3 May 2013 17:53:58 -0700
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        vgoyal@redhat.com
Subject: Re: [PATCH 29.5/32] blk-throttle: add throtl_qnode for dispatch
 fairness
Message-ID: <20130504005325.GG22860@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130504005044.GF22860@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130504005044.GF22860@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 05:50:44PM -0700, Tejun Heo wrote:
....
> +static struct bio *throtl_pop_queued(struct list_head *queued,
> +				     struct throtl_grp **tg_to_put)
> +{
> +	struct throtl_qnode *qn = list_first_entry(queued, struct throtl_qnode, node);
> +	struct bio *bio;
> +
> +	if (list_empty(queued))
> +		return NULL;
> +
> +	bio = bio_list_pop(&qn->bios);
> +	WARN_ON_ONCE(!bio);
> +
> +	if (bio_list_empty(&qn->bios)) {
> +		list_del_init(&qn->node);
> +		if (tg_to_put)
> +			*tg_to_put = qn->tg;
> +		else
> +			blkg_put(tg_to_blkg(tg_to_put));

Oops, this should have been

			blkg_put(tg_to_blkg(qn->tg));

Thanks.

-- 
tejun
