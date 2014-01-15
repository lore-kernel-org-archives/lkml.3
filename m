Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaAOJ2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:28:54 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:63276 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaAOJ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:28:51 -0500
Date: Wed, 15 Jan 2014 12:25:58 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH v2 0/4]zram: locking redesign
Message-ID: <20140115092558.GB2178@swordfish>
References: <1389748270-15618-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389748270-15618-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/15/14 10:11), Minchan Kim wrote:
> Currently, zram->lock rw_semaphore is coarse-grained so it hurts
> for scalability.
> This patch try to enhance it with remove the lock in read path.
> 
> [1] uses atomic opeartion so it removes dependency of 32bit stat
> from zram->lock.
> [2] introduces table own lock instead of relying on zram->lock.
> [3] remove free pending slot mess so it makes core very clean.
> [4] finally removes zram->lock in read path and changes it with mutex.
> 
> So, output is wonderful. read/write mixed workload performs well
> 11 times than old and write concurrency is also enhanced because
> mutex supports SPIN_ON_OWNER while rw_semaphore doesn't yet.
> (I know recenty there were some effort to enhance it for rw_semaphore
> from Tim Chen but not sure it got merged. Anyway, we don't need it
> any more and there is no reason to prevent read-write concurrency)
> 
> Thanks.
> 

Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

> Minchan Kim (4):
>   [1] zram: use atomic operation for stat
>   [2] zram: introduce zram->tb_lock
>   [3] zram: remove workqueue for freeing removed pending slot
>   [4] zram: Remove zram->lock in read path and change it with mutex
> 
>  drivers/staging/zram/zram_drv.c | 117 ++++++++++++++++------------------------
>  drivers/staging/zram/zram_drv.h |  27 +++-------
>  2 files changed, 51 insertions(+), 93 deletions(-)
> 
> -- 
> 1.8.5.2
> 
