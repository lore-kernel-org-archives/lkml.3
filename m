Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832AbaLBDDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 22:03:47 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50483 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbaLBDDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 22:03:46 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 2 Dec 2014 12:04:08 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>, Nitin Gupta <ngupta@vflare.org>,
        Luigi Semenzato <semenzato@google.com>, juno.choi@lge.com
Subject: Re: [PATCH v1 0/5] stop anon reclaim when zram is full
Message-ID: <20141202030408.GA21257@bbox>
References: <1411344191-2842-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1411344191-2842-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Mon, Sep 22, 2014 at 09:03:06AM +0900, Minchan Kim wrote:
> For zram-swap, there is size gap between virtual disksize
> and available physical memory size for zram so that VM
> can try to reclaim anonymous pages even though zram is full.
> It makes system alomost hang(ie, unresponsible) easily in
> my kernel build test(ie, 1G DRAM, CPU 12, 4G zram swap,
> 50M zram limit). VM should have killed someone.
> 
> This patch adds new hint SWAP_FULL so VM can ask fullness
> to zram and if it founds zram is full, VM doesn't reclaim
> anonymous pages until zram-swap gets new free space.
> 
> With this patch, I see OOM when zram-swap is full instead of
> hang with no response.
> 
> Minchan Kim (5):
>   zram: generalize swap_slot_free_notify
>   mm: add full variable in swap_info_struct
>   mm: VM can be aware of zram fullness
>   zram: add swap full hint
>   zram: add fullness knob to control swap full

I'm sorry for long delay for this patch althogh you guys gave great
feedback to me.

The reason I was hesitant about this patchset is that I want to avoid
weird fullness knob which was introduced by zsmalloc's internal limit.
So, before this feature, I hope we get zsmalloc's compaction firstly
Then, I hope to remove fullness knob totally.

Thanks.

> 
>  Documentation/ABI/testing/sysfs-block-zram |  10 +++
>  Documentation/filesystems/Locking          |   4 +-
>  drivers/block/zram/zram_drv.c              | 114 +++++++++++++++++++++++++++--
>  drivers/block/zram/zram_drv.h              |   2 +
>  include/linux/blkdev.h                     |   8 +-
>  include/linux/swap.h                       |   1 +
>  mm/page_io.c                               |   6 +-
>  mm/swapfile.c                              |  77 ++++++++++++++-----
>  8 files changed, 189 insertions(+), 33 deletions(-)
> 
> -- 
> 2.0.0
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
