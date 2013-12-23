Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3LWB0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 20:26:43 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42889 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab3LWB0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 20:26:41 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f156d00000276c-4a-52b7914f09f0
Content-transfer-encoding: 8BIT
Message-id: <1387761931.2101.289.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: check filename length in
 recover_dentry
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Mon, 23 Dec 2013 10:25:31 +0900
In-reply-to: <000001cefe33$b62a0f40$227e2dc0$@samsung.com>
References: <000001cefe33$b62a0f40$227e2dc0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zA13/iduDDJ43cVr8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyth0YylLwTq+iud3
	frM2MK7m7mLk5JAQMJH43nacHcIWk7hwbz1bFyMXh5DAMkaJbdu3ASU4wIp2d8ZDxBcxSmz6
	+Z0JpIFXQFDix+R7LCA1zALyEkcuZYOEmQXUJSbNW8QMUf+KUWLy599Q9boSnefXM4LYwgLB
	EguefmIC6WUT0JbYvN8AJCwkoCjxdv9dVhBbREBJ4tf8RawQMzMl5ryeDGazCKhKHHzVzgJi
	cwpYSUw8uY4NotdSYvW9hcwgNr+AqMThhduZIf5Sktjd3skOco+EwCl2if51k6AGCUh8m3yI
	BeJHWYlNB6DqJSUOrrjBMoFRYhaSL2chfDkLyZcLGJlXMYqmFiQXFCelFxnrFSfmFpfmpesl
	5+duYoREW/8OxrsHrA8xJgNtnMgsJZqcD4zWvJJ4Q2MzIwtTE1NjI3NLM9KElcR57z9MChIS
	SE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAmHdumhzr/Rhlr3wd4wv1nxLL5FaG7F37cfrEHbrx
	kZMqTgtufGR55vnT+PhnX9XeH/6Q0OEX2bl0hdt7q6+LtSYfel3Xzv8nQzLtx4Ou2WeOuNya
	XpvJ9JxF90bE2xtqS9YrLtD1Dq/PWX5uSeK1A1+W7ZE7a1KceeKc4xFBj6dX1zz7ozxlsqQS
	S3FGoqEWc1FxIgCh+zOQzAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAV3/iduDDBZfY7X43/SRzeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix6cZSloJ1fBXP7/xmbWBczd3FyMEhIWAisbszvouRE8gUk7hwbz1bFyMX
	h5DAIkaJTT+/M4EkeAUEJX5MvscCUs8sIC9x5FI2SJhZQF1i0rxFzBD1rxglJn/+DVWvK9F5
	fj0jiC0sECyx4OknJpBeNgFtic37DUDCQgKKEm/332UFsUUElCR+zV/ECjEzU2LO68lgNouA
	qsTBV+0sIDangJXExJPr2CB6LSVW31vIDGLzC4hKHF64nRnifiWJ3e2d7BMYhWYhuXoWwtWz
	kFy9gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwLD+T3sG4qsHiEKMAB6MSDy9Hy/Yg
	IdbEsuLK3EOMEhzMSiK80T+2BQnxpiRWVqUW5ccXleakFh9iTAY6fCKzlGhyPjDN5JXEGxqb
	mBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo/WTpIxMBR2FTblabN9a
	rDez2C7blLjGaf1bUdF7lwT2ZD5UWCJv/fli5/mJP5gMFsfJWXKrHF/uqbvkZsqB/7Il0p1G
	31nZl1j8EToh/kpn26nzBceXfPqlnMCsWHDnbsCq3mXhFr/mehzNkoxu+7fj5bPUuglG7yd8
	XlIyb/8RgS0Lg85vu6bEUpyRaKjFXFScCACXJ2GfKQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-12-21 (토), 18:01 +0800, Chao Yu:
> In current flow, we will get Null return value of f2fs_find_entry in
> recover_dentry when name.len is bigger than F2FS_NAME_LEN, and then we
> still add this inode into its dir entry.
> To avoid this situation, we must check filename length before we use it.
> 
> Another point is that we could remove the code of checking filename length
> In f2fs_find_entry, because f2fs_lookup will be called previously to ensure of
> validity of filename length.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/dir.c      |    3 ---
>  fs/f2fs/recovery.c |    5 +++++
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index 0cc26ba..3f3b661 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -190,9 +190,6 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *dir,
>  	unsigned int max_depth;
>  	unsigned int level;
>  
> -	if (unlikely(namelen > F2FS_NAME_LEN))
> -		return NULL;
> -
>  	if (npages == 0)
>  		return NULL;
>  
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index a3f4542..fdd175b 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -62,6 +62,11 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
>  
>  	name.len = le32_to_cpu(raw_inode->i_namelen);
>  	name.name = raw_inode->i_name;
> +
> +	if (unlikely(name.len > F2FS_NAME_LEN)) {
> +		err = -ENAMETOOLONG;
> +		goto out;
> +	}

Have you seen this before?
This is a trivial bug case, so, if you have got this bug, we should fix
the bug first instead of adding any workaround patch.
Let's add WARN_ON() at least.
Thanks,

>  retry:
>  	de = f2fs_find_entry(dir, &name, &page);
>  	if (de && inode->i_ino == le32_to_cpu(de->ino))

-- 
Jaegeuk Kim
Samsung

