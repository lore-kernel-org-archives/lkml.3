Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab3JRPqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:46:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52700 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab3JRPqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:46:15 -0400
Date: Fri, 18 Oct 2013 09:46:10 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, l.flis@cyfronet.pl
Subject: Re: [PATCH] block: properly stack underlying max_segment_size to DM
 device
Message-ID: <20131018154610.GA9304@kernel.dk>
References: <1382106206-4459-1-git-send-email-snitzer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382106206-4459-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18 2013, Mike Snitzer wrote:
> Without this patch all DM devices will default to BLK_MAX_SEGMENT_SIZE
> (65536) even if the underlying device(s) have a larger value -- this is
> due to blk_stack_limits() using min_not_zero() when stacking the
> max_segment_size limit.
> 
> # cat /sys/block/sda/queue/max_segment_size
> 1073741824
> 
> # cat /sys/block/dm-0/queue/max_segment_size
> before patch:
> 65536
> 
> after patch:
> 1073741824
> 
> Reported-by: Lukasz Flis <l.flis@cyfronet.pl>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: stable@vger.kernel.org # v3.3+
> ---
>  block/blk-settings.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index c50ecf0..29f28bb 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -143,6 +143,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>  	/* Inherit limits from component devices */
>  	lim->discard_zeroes_data = 1;
>  	lim->max_segments = USHRT_MAX;
> +	lim->max_segment_size = UINT_MAX;
>  	lim->max_hw_sectors = UINT_MAX;
>  	lim->max_sectors = UINT_MAX;
>  	lim->max_write_same_sectors = UINT_MAX;

Thanks, applied for 3.13.

-- 
Jens Axboe

