Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaAOJWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:22:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaAOJWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:22:18 -0500
Message-ID: <52D6530B.30109@redhat.com>
Date: Wed, 15 Jan 2014 10:21:15 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH v2 0/4]zram: locking redesign
References: <1389748270-15618-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1389748270-15618-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 02:11 AM, Minchan Kim wrote:
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

The new locking scheme seems sound to me.

Acked-by: Jerome Marchand <jmarchan@redhat.com>
