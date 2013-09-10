Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab3IJAzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:55:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50633 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3IJAzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:55:15 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-7b-522e6df12468
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1378774503.2354.106.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: optimize fs_lock for better performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Russ Knize <Russ.Knize@motorola.com>
Cc: chao2.yu@samsung.com, linux-fsdevel@vger.kernel.org, shu.tan@samsung.com,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Tue, 10 Sep 2013 09:55:03 +0900
In-reply-to: <CAGfvh62EGuQfGBRhasNEXAVEvS2BwKCijnAS67f+GL2fHS-fTA@mail.gmail.com>
References: <02.95.21086.AD4A9225@epcpsbgx4.samsung.com>
 <CAGfvh62EGuQfGBRhasNEXAVEvS2BwKCijnAS67f+GL2fHS-fTA@mail.gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zA92PuXpBBk9fm1v8b/rIZnFpkbvF
	nr0nWSwu75rDZrFw8gcWi9aF55kd2Dx2L/jM5NFz6i2zR9+WVYwenzfJBbBEcdmkpOZklqUW
	6dslcGV0XtrGWrDQoGJ1w0mmBsZWmS5GDg4JAROJ319Suhg5gUwxiQv31rN1MXJxCAksY5Ro
	vLSVESJhIvG8YToriC0ksIhRYv2EKBCbV0BQ4sfkeywgNrOAusSkeYuYIWwRiWl/b7BC2NoS
	yxa+ZoYY+ppRYv7pH8wQzboSlx9sYQKxhQV8JRqPvWcEOYgNqGHzfgOIXYoSb/ffBZsjIqAh
	saWviRVkDrPAFEaJNRtvgM1hEVCV+HPzKJjNKRAssXjPGiaI5nqJq+t7wGx+AVGJwwu3M0M8
	oySxu72THWSQhMAtdokz356yQQwSkPg2+RALJFRkJTYdgKqXlDi44gbLBEbJWUh+noXk51lI
	fp6F5OcFjCyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MULit38H490D1ocYk4HWT2SWEk3O
	B8Z/Xkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY
	JVabRkZvCHfYccds2cXyghMSMfWnTiqaftnxocY0bou17VmFbdoWe9iOmpxUvhL++8eiWdIM
	ASsliuoDpJS+tX5hmpdYWfb7yOljieEtbWodMYxzX2pGq3u0Ckstevjv/Ov7P2coVmZ5C90U
	XWLkwzPhru2+wC2aBhH5JaW2mekbFi+60nJRiaU4I9FQi7moOBEAnBsiTPUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd2PuXpBBt8bjS3+N31ks7i0yN1i
	z96TLBaXd81hs1g4+QOLRevC88wObB67F3xm8ug59ZbZo2/LKkaPz5vkAliiGhhtMlITU1KL
	FFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CWKymUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz/ky5xFTQblCxcdtCtgbG19JdjJwcEgImEs8b
	prNC2GISF+6tZwOxhQQWMUqsnxAFYvMKCEr8mHyPpYuRg4NZQF7iyKVskDCzgLrEpHmLmLsY
	uYDKXzNKzD/9gxmiXlfi8oMtTCC2sICvROOx94wgvWwC2hKb9xtAjFeUeLv/LthaEQENiS19
	Tawgc5gFpjBKrNl4A2wOi4CqxJ+bR8FsToFgicV71jBBNNdLXF3fA2bzC4hKHF64nRnifiWJ
	3e2d7BMYhWYhOXsWwtmzkJy9gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwrD+T2sG4
	ssHiEKMAB6MSD6/GO90gIdbEsuLK3EOMEhzMSiK8G5j1goR4UxIrq1KL8uOLSnNSiw8xJgMd
	PpFZSjQ5H5iG8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB
	Mf/2eouZonZBkzZN/p63hD+7UvDlVZWVOZKRDtb+zKoR9xgsrbSECyY+/6Hnk7n/0m/35JN6
	ac+qsndMmPUkuv3hR6Zu0dVvuaQ3hwlUfTohq8bxwNZeqcaz3Pa54L7MZxe0zpso7eD9fZ/N
	p8R5rlC8b0POokWHq5bKiE478MLoJY9LwcVJSizFGYmGWsxFxYkAyAYfBTkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Nice catch.
This is definitely a bug where one thread grabbed two fs_locks across
the same flow.
Any idea?
Thanks,

2013-09-06 (금), 14:25 -0500, Russ Knize:
> I encountered this same issue recently and solved it in much the same
> way.  Can we rename "spin_lock" to something more meaningful?
> 
> 
> This race actually exposed a potential deadlock between f2fs_create()
> and f2fs_initxattrs():
> 
> 
> - vfs_create()
>  - f2fs_create() - takes an fs_lock
>   - f2fs_add_link()
>    - __f2fs_add_link()
>     - init_inode_metadata()
>      - f2fs_init_security()
>       - security_inode_init_security()
>        - f2fs_initxattrs()
>         - f2fs_setxattr() - also takes an fs_lock
> 
> 
> If another CPU happens to have the same lock that f2fs_setxattr() was
> trying to take because of the race around next_lock_num, we can get
> into a deadlock situation if the two threads are also contending over
> another resource (like bdi).
> 
> 
> Another scenario is if the above happens while another thread is in
> the middle of grabbing all of the locks via mutex_lock_all().
>  f2fs_create() is holding a lock that mutex_lock_all() is waiting for
> and mutex_lock_all() is holding a lock that f2fs_setxattr() is waiting
> for.
> 
> 
> Russ
> 
> 
> On Fri, Sep 6, 2013 at 4:48 AM, Chao Yu <chao2.yu@samsung.com> wrote:
>         Hi Kim:
>         
>              I think there is a performance problem: when all
>         sbi->fs_lock is holded, 
>         
>         then all other threads may get the same next_lock value from
>         sbi->next_lock_num in function mutex_lock_op, 
>         
>         and wait to get the same lock at position fs_lock[next_lock],
>         it unbalance the fs_lock usage. 
>         
>         It may lost performance when we do the multithread test.
>         
>          
>         
>         Here is the patch to fix this problem:
>         
>          
>         
>         Signed-off-by: Yu Chao <chao2.yu@samsung.com>
>         
>         diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>         
>         old mode 100644
>         
>         new mode 100755
>         
>         index 467d42d..983bb45
>         
>         --- a/fs/f2fs/f2fs.h
>         
>         +++ b/fs/f2fs/f2fs.h
>         
>         @@ -371,6 +371,7 @@ struct f2fs_sb_info {
>         
>                 struct mutex fs_lock[NR_GLOBAL_LOCKS];  /* blocking FS
>         operations */
>         
>                 struct mutex node_write;                /* locking
>         node writes */
>         
>                 struct mutex writepages;                /* mutex for
>         writepages() */
>         
>         +       spinlock_t spin_lock;                   /* lock for
>         next_lock_num */
>         
>                 unsigned char next_lock_num;            /* round-robin
>         global locks */
>         
>                 int por_doing;                          /* recovery is
>         doing or not */
>         
>                 int on_build_free_nids;                 /*
>         build_free_nids is doing */
>         
>         @@ -533,15 +534,19 @@ static inline void
>         mutex_unlock_all(struct f2fs_sb_info *sbi)
>         
>          
>         
>          static inline int mutex_lock_op(struct f2fs_sb_info *sbi)
>         
>          {
>         
>         -       unsigned char next_lock = sbi->next_lock_num %
>         NR_GLOBAL_LOCKS;
>         
>         +       unsigned char next_lock;
>         
>                 int i = 0;
>         
>          
>         
>                 for (; i < NR_GLOBAL_LOCKS; i++)
>         
>                         if (mutex_trylock(&sbi->fs_lock[i]))
>         
>                                 return i;
>         
>          
>         
>         -       mutex_lock(&sbi->fs_lock[next_lock]);
>         
>         +       spin_lock(&sbi->spin_lock);
>         
>         +       next_lock = sbi->next_lock_num % NR_GLOBAL_LOCKS;
>         
>                 sbi->next_lock_num++;
>         
>         +       spin_unlock(&sbi->spin_lock);
>         
>         +
>         
>         +       mutex_lock(&sbi->fs_lock[next_lock]);
>         
>                 return next_lock;
>         
>          }
>         
>          
>         
>         diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
>         
>         old mode 100644
>         
>         new mode 100755
>         
>         index 75c7dc3..4f27596
>         
>         --- a/fs/f2fs/super.c
>         
>         +++ b/fs/f2fs/super.c
>         
>         @@ -657,6 +657,7 @@ static int f2fs_fill_super(struct
>         super_block *sb, void *data, int silent)
>         
>                 mutex_init(&sbi->cp_mutex);
>         
>                 for (i = 0; i < NR_GLOBAL_LOCKS; i++)
>         
>                         mutex_init(&sbi->fs_lock[i]);
>         
>         +       spin_lock_init(&sbi->spin_lock);
>         
>                 mutex_init(&sbi->node_write);
>         
>                 sbi->por_doing = 0;
>         
>                 spin_lock_init(&sbi->stat_lock);
>         
>         (END)
>         
>          
>         
>         
>         
>         
>         
>         ------------------------------------------------------------------------------
>         Learn the latest--Visual Studio 2012, SharePoint 2013, SQL
>         2012, more!
>         Discover the easy way to master current and previous Microsoft
>         technologies
>         and advance your career. Get an incredible 1,500+ hours of
>         step-by-step
>         tutorial videos with LearnDevNow. Subscribe today and save!
>         http://pubads.g.doubleclick.net/gampad/clk?id=58041391&iu=/4140/ostg.clktrk
>         _______________________________________________
>         Linux-f2fs-devel mailing list
>         Linux-f2fs-devel@lists.sourceforge.net
>         https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
>         
> 
> 

-- 
Jaegeuk Kim
Samsung

