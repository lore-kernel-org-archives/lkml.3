Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab3DASoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:44:08 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61360 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944Ab3DASoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:44:07 -0400
Date: Mon, 1 Apr 2013 11:44:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 tj/for-3.10] workqueue: add wq->freezing and remove
 POOL_FREEZING
Message-ID: <20130401184402.GA31435@htj.dyndns.org>
References: <1364660955-5217-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364660955-5217-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 31, 2013 at 12:29:14AM +0800, Lai Jiangshan wrote:
> freezing is nothing related to pools, but POOL_FREEZING adds a connection,
> and causes freeze_workqueues_begin() and thaw_workqueues() complicated.
> 
> Since freezing is workqueue instance attribute, so we introduce wq->freezing
> instead and remove POOL_FREEZING.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |   33 +++++++--------------------------
>  1 files changed, 7 insertions(+), 26 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 04a8b98..6b7e5a4 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -66,7 +66,6 @@ enum {
>  	 */
>  	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
>  	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
> -	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
>  
>  	/* worker flags */
>  	WORKER_STARTED		= 1 << 0,	/* started */
> @@ -241,6 +240,7 @@ struct workqueue_struct {
>  
>  	int			nr_drainers;	/* WQ: drain in progress */
>  	int			saved_max_active; /* WQ: saved pwq max_active */
> +	bool			freezing;	/* WQ: the wq is freezing */

Why not use another internal flag?  There already are __WQ_DRAINING
and __WQ_ORDERED.  Can't we just add __WQ_FREEZING?

Thanks.

-- 
tejun
