Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3BDCBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 21:01:52 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:57959 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab3BDCBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 21:01:49 -0500
MIME-Version: 1.0
In-Reply-To: <1359941761.2739.39.camel@lcm>
References: <1359816733-16286-1-git-send-email-linkinjeon@gmail.com>
	<1359941761.2739.39.camel@lcm>
Date: Mon, 4 Feb 2013 11:01:48 +0900
Message-ID: <CAKYAXd8pnjAPNkSO4rrjupnbvP9S+8hEta_NMM_oT--yGVhF4w@mail.gmail.com>
Subject: Re: [PATCH 2/6] f2fs: move out f2fs_balance_fs from gc_thread_func
From: Namjae Jeon <linkinjeon@gmail.com>
To: Changman Lee <cm224.lee@samsung.com>
Cc: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/4, Changman Lee <cm224.lee@samsung.com>:
> As you know, f2fs_balance_fs conducts gc if f2fs has not enough free
> sections. But, the purpose of background gc is to conduct gc during idle
> time without checking free sections so that f2fs can solve defragment
> condition.
>
> Could you review this?
Yes, right. make sense.
This patch also looks good to me.
Thanks a lot !
>
> --> 8 --
>
> From fbda3262dac81c4f0d7ae8b9b757c820da593120 Mon Sep 17 00:00:00 2001
> From: Changman Lee <cm224.lee@samsung.com>
> Date: Mon, 4 Feb 2013 10:05:09 +0900
> Subject: [PATCH] f2fs: remove unnecessary gc option check and balance_fs
>
>  1. If f2fs is mounted with background_gc_off option, checking
>     BG_GC is not redundant.
>  2. f2fs_balance_fs is checked in f2fs_gc, so this is also redundant.
>
> Signed-off-by: Changman Lee <cm224.lee@samsung.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/gc.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index 8fe43f3..e5c47f6 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -49,11 +49,6 @@ static int gc_thread_func(void *data)
>  			continue;
>  		}
>
> -		f2fs_balance_fs(sbi);
> -
> -		if (!test_opt(sbi, BG_GC))
> -			continue;
> -
>  		/*
>  		 * [GC triggering condition]
>  		 * 0. GC is not conducted currently.
> @@ -96,6 +91,8 @@ int start_gc_thread(struct f2fs_sb_info *sbi)
>  {
>  	struct f2fs_gc_kthread *gc_th;
>
> +	if (!test_opt(sbi, BG_GC))
> +		return 0;
>  	gc_th = kmalloc(sizeof(struct f2fs_gc_kthread), GFP_KERNEL);
>  	if (!gc_th)
>  		return -ENOMEM;
> --
> 1.7.10.4
>
>
>
>
