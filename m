Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaAOB3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:29:04 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45830 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOB3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:29:02 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-e3-52d5e45c777d
Date: Wed, 15 Jan 2014 10:29:48 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH v2 0/4]zram: locking redesign
Message-ID: <20140115012948.GE1992@bbox>
References: <1389748270-15618-1-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389748270-15618-1-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 10:11:06AM +0900, Minchan Kim wrote:
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
> -- 
> 1.8.5.2
> 

Oops, I missed Tested-by from Sergey. Really, sorry.
If I have a chance to resend from any review, I will add. Otherwise,
Andrew, Could you add his tested-by?

This patch is same with v1.
I just updated description from Andrew and Jerome's comment.

-- 
Kind regards,
Minchan Kim
