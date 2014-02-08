Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaBHSiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 13:38:11 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39287 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaBHSiK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 13:38:10 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 8 Feb 2014 10:38:04 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] block: Mark function as static in blk-throttle.c
Message-ID: <20140208183804.GC14801@leaf>
References: <7dce86ade62eada14e58bb334bb9b7bd87627b68.1391876538.git.rashika.kheria@gmail.com>
 <44a81d7a082f5e30aaa7a2428421beddbc934293.1391876538.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <44a81d7a082f5e30aaa7a2428421beddbc934293.1391876538.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 09:56:21PM +0530, Rashika Kheria wrote:
> Mark functions as static in blk-throttle.c because it is not used
> outside this file.
> 
> This eliminates the following warning in blk-throttle.c:
> block/blk-throttle.c:1261:6: warning: no previous prototype for ‘blk_throtl_dispatch_work_fn’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  block/blk-throttle.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 1474c3a..0face33 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -1258,7 +1258,7 @@ out_unlock:
>   * of throtl_data->service_queue.  Those bio's are ready and issued by this
>   * function.
>   */
> -void blk_throtl_dispatch_work_fn(struct work_struct *work)
> +static void blk_throtl_dispatch_work_fn(struct work_struct *work)
>  {
>  	struct throtl_data *td = container_of(work, struct throtl_data,
>  					      dispatch_work);
> -- 
> 1.7.9.5
> 
