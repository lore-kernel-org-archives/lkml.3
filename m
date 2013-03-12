Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab3CLMCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:02:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab3CLMCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:02:05 -0400
Date: Tue, 12 Mar 2013 13:02:00 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, laijs@cn.fujitsu.com, fengguang.wu@intel.com,
        linux-kernel@vger.kernel.org, jmoyer@redhat.com
Subject: Re: [PATCH 2/4] writeback: remove unused bdi_pending_list
Message-ID: <20130312120200.GD13152@quack.suse.cz>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
 <1362692649-25570-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362692649-25570-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 07-03-13 13:44:07, Tejun Heo wrote:
> There's no user left.  Remove it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
  Looks good. You can add
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/backing-dev.h | 1 -
>  mm/backing-dev.c            | 4 +---
>  2 files changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 3504599..a5ef27f 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -130,7 +130,6 @@ void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2);
>  
>  extern spinlock_t bdi_lock;
>  extern struct list_head bdi_list;
> -extern struct list_head bdi_pending_list;
>  
>  static inline int wb_has_dirty_io(struct bdi_writeback *wb)
>  {
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 41733c5..657569b 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -31,13 +31,11 @@ EXPORT_SYMBOL_GPL(noop_backing_dev_info);
>  static struct class *bdi_class;
>  
>  /*
> - * bdi_lock protects updates to bdi_list and bdi_pending_list, as well as
> - * reader side protection for bdi_pending_list. bdi_list has RCU reader side
> + * bdi_lock protects updates to bdi_list. bdi_list has RCU reader side
>   * locking.
>   */
>  DEFINE_SPINLOCK(bdi_lock);
>  LIST_HEAD(bdi_list);
> -LIST_HEAD(bdi_pending_list);
>  
>  void bdi_lock_two(struct bdi_writeback *wb1, struct bdi_writeback *wb2)
>  {
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
