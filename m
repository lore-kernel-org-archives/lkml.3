Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab3LDCU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:20:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36148 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3LDCU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:20:26 -0500
Date: Tue, 3 Dec 2013 19:20:16 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 21/41] block: Replace __this_cpu_ptr with raw_cpu_ptr
Message-ID: <20131204022016.GE5051@kernel.dk>
References: <20131203233232.928771708@linux.com>
 <20131203233255.999121189@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203233255.999121189@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03 2013, Christoph Lameter wrote:
> __this_cpu_ptr is being phased out.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/fs/ext4/mballoc.c
> ===================================================================
> --- linux.orig/fs/ext4/mballoc.c	2013-12-02 16:07:53.574528512 -0600
> +++ linux/fs/ext4/mballoc.c	2013-12-02 16:07:53.574528512 -0600
> @@ -4085,7 +4085,7 @@ static void ext4_mb_group_or_file(struct
>  	 * per cpu locality group is to reduce the contention between block
>  	 * request from multiple CPUs.
>  	 */
> -	ac->ac_lg = __this_cpu_ptr(sbi->s_locality_groups);
> +	ac->ac_lg = raw_cpu_ptr(sbi->s_locality_groups);
>  
>  	/* we're going to use group allocation */
>  	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
> Index: linux/fs/buffer.c
> ===================================================================
> --- linux.orig/fs/buffer.c	2013-12-02 16:07:53.574528512 -0600
> +++ linux/fs/buffer.c	2013-12-02 16:07:53.574528512 -0600
> @@ -1312,7 +1312,7 @@ static void bh_lru_install(struct buffer
>  		}
>  		while (out < BH_LRU_SIZE)
>  			bhs[out++] = NULL;
> -		memcpy(__this_cpu_ptr(&bh_lrus.bhs), bhs, sizeof(bhs));
> +		memcpy(this_cpu_ptr(&bh_lrus.bhs), bhs, sizeof(bhs));
>  	}
>  	bh_lru_unlock();

Christoph, I applied the fs/buffer.c bit, the ext4 one should probably
go through Ted.

-- 
Jens Axboe

