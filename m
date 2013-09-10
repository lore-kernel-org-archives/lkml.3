Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3IJA7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:59:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54785 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab3IJA7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:59:21 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f3b6d000007a15-cd-522e6ee8b781
Content-transfer-encoding: 8BIT
Message-id: <1378774750.2354.110.camel@kjgkr>
Subject: Re: Re: [f2fs-dev] [PATCH] f2fs: optimize fs_lock for better
 performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: chao2.yu@samsung.com
Cc: Russ Knize <Russ.Knize@motorola.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
	<linux-f2fs-devel@lists.sourceforge.net>
Date: Tue, 10 Sep 2013 09:59:10 +0900
In-reply-to: <04.C0.13361.61DDA225@epcpsbge5.samsung.com>
References: <04.C0.13361.61DDA225@epcpsbge5.samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t8zI90XeXpBBnP6xCz+N31ks7i0yN1i
	z96TLBaXd81hs1g4+QOLRevC88wObB67F3xm8ug59ZbZo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDI+fJYraLOq2H1CvYFxinIXIyeHhICJxLOlm1ghbDGJC/fWs3UxcnEICSxjlPh7ZAU7
	TNH+lS9ZIBKLGCXOvj8F1sErICjxY/I9oAQHB7OAvMSRS9kgYWYBdYlJ8xYxQ9S/ZpRov9DG
	BlGvK/H20SYWEFtYIFiie9VUJpBeNgFtic37DUDCQgKKEm/33wUbLyIgIfFs1nQmkDnMAruZ
	JL4uncMIkmARUJU4vn4lM4jNKWApse7ELCaIZguJuU+ng9n8AqIShxduZ4Z4QElid3snO8gg
	CYF77BK73jWyQgwSkPg2+RDYAxICshKbDkDVS0ocXHGDZQKjxCwkb85CeHMWkjcXMDKvYhRN
	LUguKE5KLzLRK07MLS7NS9dLzs/dxAiJxQk7GO8dsD7EmAy0cSKzlGhyPjCW80riDY3NjCxM
	TUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAGGV0J1z33DnfyPYa
	xrqTfZu5d8yuLvu7/JdIZSNbfH/Ng1uGU+445RxsKzw14+mmzGl+T+a9kPZX1atVuXLdXeT7
	ia63LK7Ztuaf5uybzW/wXjJYRHlKzxGONVuPMUVfbwtd1bPERnfLNL9OC0Ve29InzXaXmO9V
	v4sS2aCRlKPwtJE34dtRJZbijERDLeai4kQAQez+9tsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jAd0XeXpBBj3vBCz+N31ks7i0yN1i
	z96TLBaXd81hs1g4+QOLRevC88wObB67F3xm8ug59ZbZo2/LKkaPz5vkAliiGhhtMlITU1KL
	FFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CWKymUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzPnyWK2izqth9Qr2BcYpyFyMnh4SAicT+lS9Z
	IGwxiQv31rN1MXJxCAksYpQ4+/4UK0iCV0BQ4sfke0BFHBzMAvISRy5lg4SZBdQlJs1bxAxR
	/5pRov1CGxtEva7E20ebwIYKCwRLdK+aygTSyyagLbF5vwFIWEhAUeLt/rtg40UEJCSezZrO
	BDKHWWA3k8TXpXMYQRIsAqoSx9evZAaxOQUsJdadmMUE0WwhMffpdDCbX0BU4vDC7cwQDyhJ
	7G7vZJ/AKDQLydmzEM6eheTsBYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI/2Z1A7G
	lQ0WhxgFOBiVeHg13ukGCbEmlhVX5h5ilOBgVhLh3cCsFyTEm5JYWZValB9fVJqTWnyIMRno
	8InMUqLJ+cAklFcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFIN
	jOkzJnhkZH1fv3xRh15QjitPjemstozOY9NPsaRWrX6poXhbdEJY0ff+Cwc2Gv8O9mL/8PD8
	khil559XWqrvCjn1NddP8WQ0wwPZLUEW83/NMinJCvyz1u6SxiXBq5FHA65K+WZbPtsgeknB
	Tdn84rTdq/IuvfieWaRp/vmV0ezVb4/MVp+xtleJpTgj0VCLuag4EQBChvBDOAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-09-07 (토), 08:00 +0000, Chao Yu:
> Hi Knize,
> 
>     Thanks for your reply, I think it's actually meaningless that it's
> being named after "spin_lock",
> it's better to rename this spinlock to "round_robin_lock".
> 
>     This patch can only resolve the issue of unbalanced fs_lock usage,
> it can not fix the deadlock issue.
> can we fix deadlock issue through this method:
> 
> - vfs_create()
>  - f2fs_create() - takes an fs_lock and save current thread info into
> thread_info[NR_GLOBAL_LOCKS]
>   - f2fs_add_link()
>    - __f2fs_add_link()
>     - init_inode_metadata()
>      - f2fs_init_security()
>       - security_inode_init_security()
>        - f2fs_initxattrs()
>         - f2fs_setxattr() - get fs_lock only if there is no current
> thread info in thread_info
>         
> So it keeps one thread can only hold one fs_lock to avoid deadlock.
> Can we use this solution?

It could be.
But, I think we can avoid to grab the fs_lock at the f2fs_initxattrs()
level, since this case only happens when f2fs_initxattrs() is called.
Let's think about ut in more detail.
Thanks,

> 
>  
> 
> thanks again!
> 
>  
> 
> ------- Original Message -------
> 
> Sender : Russ Knize<Russ.Knize@motorola.com>
> 
> Date : 九月 07, 2013 04:25 (GMT+09:00)
> 
> Title : Re: [f2fs-dev] [PATCH] f2fs: optimize fs_lock for better
> performance
> 
>  
> 
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
>  
> 
>  
> 
>  
> 
> 
> 
> 

-- 
Jaegeuk Kim
Samsung

