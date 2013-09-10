Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3IJAwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:52:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53501 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3IJAwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:52:18 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f656d0000058e3-2c-522e6d3e6042
Content-transfer-encoding: 8BIT
Message-id: <1378774324.2354.103.camel@kjgkr>
Subject: Re: [f2fs-dev][PATCH] f2fs: optimize fs_lock for better performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: chao2.yu@samsung.com
Cc: shu.tan@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Tue, 10 Sep 2013 09:52:04 +0900
In-reply-to: <88.C4.11914.9D4A9225@epcpsbge6.samsung.com>
References: <88.C4.11914.9D4A9225@epcpsbge6.samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zQ137XL0gg6Yki/9NH9ksLi1yt9iz
	9ySLxeVdc9gsWheeZ3Zg9di94DOTR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGUcOL6FseC7
	ZMWmXrsGxmuCXYycHBICJhIPdh5ihrDFJC7cW8/WxcjFISSwjFHi4NulzDBFjTvPQSUWMUps
	7TjHApLgFRCU+DH5HpDNwcEsIC9x5FI2SJhZQF1i0rxFzBD1rxklZn45zwxRryux+9lxJpB6
	YQEfiW/7nUBMNgFtic37DUAqhAQUJd7uv8sKYosISEg8mzWdCWJ6ncSOA6ogYRYBVYmdf9az
	g4Q5BSwl5jclQHRaSMza+4ANxOYXEJU4vHA71PFKErvbO9lBjpEQOMYu8XP/VEaIOQIS3yYf
	AjteQkBWYtMBqHpJiYMrbrBMYJSYheTFWQgvzkLy4gJG5lWMoqkFyQXFSelFxnrFibnFpXnp
	esn5uZsYIfHWv4Px7gHrQ4zJQBsnMkuJJucD4zWvJN7Q2MzIwtTE1NjI3NKMNGElcV61FutA
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxHXjJXyhxVr+bIWfvQ7krHzEDF06Xckd4TtC+k
	OX3bGemYa6rVfHfOF6P+C13zp6aJBs7+cy7uaPK+0C21r3/wVi2/mSzRsHgJW5n5AZ5UdqHe
	tsKi0AmrJjN0Cq78NFX4yN/41Wqv9KdUTQ7xjqhTN5zmOrXBeUl29MVrZ99pmsbcLtys9UWJ
	pTgj0VCLuag4EQAtTLHczQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAV27XL0ggzO7LSz+N31ks7i0yN1i
	z96TLBaXd81hs2hdeJ7ZgdVj94LPTB59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmHHg+BbGgu+SFZt67RoYrwl2MXJySAiYSDTuPMcGYYtJXLi3Hsjm
	4hASWMQosbXjHAtIgldAUOLH5HtANgcHs4C8xJFL2SBhZgF1iUnzFjFD1L9mlJj55TwzRL2u
	xO5nx5lA6oUFfCS+7XcCMdkEtCU27zcAqRASUJR4u/8uK4gtIiAh8WzWdCaI6XUSOw6ogoRZ
	BFQldv5Zzw4S5hSwlJjflADRaSExa+8DsIP5BUQlDi/czgxxvJLE7vZO9gmMQrOQnDwL4eRZ
	SE5ewMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4np9J7WBc2WBxiFGAg1GJh1fjnW6Q
	EGtiWXFl7iFGCQ5mJRHeDcx6QUK8KYmVValF+fFFpTmpxYcYk4HunsgsJZqcD0w1eSXxhsYm
	ZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXA6D3nIP/LeQrlFtbS/K0v
	AxP+Z9qzep2fdu9yf2XqvQVdUdtimX7GPvpd874jQvDdlE26trJn9Bjq8pk55FZ/mMrzPJmn
	blJopjbnr7/9ZWG+kntTLJbJPVw8+YQQdyOnbm7hm1kq4TolLsJpT9Z4rFCRSN2zqiLdP71x
	ScArlq91e2/sWf9UiaU4I9FQi7moOBEAE4Ai8SsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

At first, thank you for the report and please follow the email writing
rules. :)

Anyway, I agree to the below issue.
One thing that I can think of is that we don't need to use the
spin_lock, since we don't care about the exact lock number, but just
need to get any not-collided number.

So, how about removing the spin_lock?
And how about using a random number?
Thanks,

2013-09-06 (금), 09:48 +0000, Chao Yu:
> Hi Kim:
> 
>      I think there is a performance problem: when all sbi->fs_lock is
> holded, 
> 
> then all other threads may get the same next_lock value from
> sbi->next_lock_num in function mutex_lock_op, 
> 
> and wait to get the same lock at position fs_lock[next_lock], it
> unbalance the fs_lock usage. 
> 
> It may lost performance when we do the multithread test.
> 
>  
> 
> Here is the patch to fix this problem:
> 
>  
> 
> Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> 
> old mode 100644
> 
> new mode 100755
> 
> index 467d42d..983bb45
> 
> --- a/fs/f2fs/f2fs.h
> 
> +++ b/fs/f2fs/f2fs.h
> 
> @@ -371,6 +371,7 @@ struct f2fs_sb_info {
> 
>         struct mutex fs_lock[NR_GLOBAL_LOCKS];  /* blocking FS
> operations */
> 
>         struct mutex node_write;                /* locking node writes
> */
> 
>         struct mutex writepages;                /* mutex for
> writepages() */
> 
> +       spinlock_t spin_lock;                   /* lock for
> next_lock_num */
> 
>         unsigned char next_lock_num;            /* round-robin global
> locks */
> 
>         int por_doing;                          /* recovery is doing
> or not */
> 
>         int on_build_free_nids;                 /* build_free_nids is
> doing */
> 
> @@ -533,15 +534,19 @@ static inline void mutex_unlock_all(struct
> f2fs_sb_info *sbi)
> 
>  
> 
>  static inline int mutex_lock_op(struct f2fs_sb_info *sbi)
> 
>  {
> 
> -       unsigned char next_lock = sbi->next_lock_num %
> NR_GLOBAL_LOCKS;
> 
> +       unsigned char next_lock;
> 
>         int i = 0;
> 
>  
> 
>         for (; i < NR_GLOBAL_LOCKS; i++)
> 
>                 if (mutex_trylock(&sbi->fs_lock[i]))
> 
>                         return i;
> 
>  
> 
> -       mutex_lock(&sbi->fs_lock[next_lock]);
> 
> +       spin_lock(&sbi->spin_lock);
> 
> +       next_lock = sbi->next_lock_num % NR_GLOBAL_LOCKS;
> 
>         sbi->next_lock_num++;
> 
> +       spin_unlock(&sbi->spin_lock);
> 
> +
> 
> +       mutex_lock(&sbi->fs_lock[next_lock]);
> 
>         return next_lock;
> 
>  }
> 
>  
> 
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> 
> old mode 100644
> 
> new mode 100755
> 
> index 75c7dc3..4f27596
> 
> --- a/fs/f2fs/super.c
> 
> +++ b/fs/f2fs/super.c
> 
> @@ -657,6 +657,7 @@ static int f2fs_fill_super(struct super_block *sb,
> void *data, int silent)
> 
>         mutex_init(&sbi->cp_mutex);
> 
>         for (i = 0; i < NR_GLOBAL_LOCKS; i++)
> 
>                 mutex_init(&sbi->fs_lock[i]);
> 
> +       spin_lock_init(&sbi->spin_lock);
> 
>         mutex_init(&sbi->node_write);
> 
>         sbi->por_doing = 0;
> 
>         spin_lock_init(&sbi->stat_lock);
> 
> (END)
> 
>  
> 
> 
> 
> 

-- 
Jaegeuk Kim
Samsung

