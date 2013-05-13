Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab3EMJ2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:28:34 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:55717 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3EMJ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:28:33 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/fat: Use fat_msg() to replace printk() in __fat_fs_error()
References: <5190AAB9.5080904@cn.fujitsu.com>
Date: Mon, 13 May 2013 18:28:27 +0900
In-Reply-To: <5190AAB9.5080904@cn.fujitsu.com> (Gu Zheng's message of "Mon, 13
	May 2013 16:56:25 +0800")
Message-ID: <87obcfqldw.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu Zheng <guz.fnst@cn.fujitsu.com> writes:

>>From 87141ec058aad35ac55bc7c3fc2eb378566a5a6a Mon Sep 17 00:00:00 2001
> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Date: Mon, 13 May 2013 17:48:19 +0900
> Subject: [PATCH] fs/fat: Use fat_msg() to replace printk() in __fat_fs_error()

> -		printk(KERN_ERR "FAT-fs (%s): error, %pV\n", sb->s_id, &vaf);
> +		fat_msg(sb, KERN_ERR, "error, %pV", &vaf);
>  		va_end(args);

I'm assuming nested "%pV" is works fine. If so,

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

> @@ -38,8 +38,7 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
>  		panic("FAT-fs (%s): fs panic from previous error\n", sb->s_id);
>  	else if (opts->errors == FAT_ERRORS_RO && !(sb->s_flags & MS_RDONLY)) {
>  		sb->s_flags |= MS_RDONLY;
> -		printk(KERN_ERR "FAT-fs (%s): Filesystem has been "
> -				"set read-only\n", sb->s_id);
> +		fat_msg(sb, KERN_ERR, "Filesystem has been set read-only");
>  	}
>  }
>  EXPORT_SYMBOL_GPL(__fat_fs_error);

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
