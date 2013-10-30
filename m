Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab3J3Rwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:52:40 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:43271 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3J3Rwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:52:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_bHP-DMMbsFkc1RwmDK4dp+cZY8LRBFyDDuoEohJ-O_g@mail.gmail.com>
References: <CAPgLHd_bHP-DMMbsFkc1RwmDK4dp+cZY8LRBFyDDuoEohJ-O_g@mail.gmail.com>
Date: Wed, 30 Oct 2013 10:52:38 -0700
X-Google-Sender-Auth: vxOIpavRRBoVV8CRuWAqjzznjnk
Message-ID: <CAGXu5jKRTv_xW1kbPBR+GYNDvPTb5rirFXNZjGH17Rsssh8q4A@mail.gmail.com>
Subject: Re: [PATCH] befs: fix return value check in befs_iget()
From: Kees Cook <keescook@chromium.org>
To: Wei Yongjun <weiyj.lk@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        yongjun_wei@trendmicro.com.cn, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 7:00 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function iget_locked() returns NULL pointer
> not ERR_PTR(). The IS_ERR() test in the return value check should
> be replaced with NULL test.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Good catch, thanks!

Acked-by: Kees Cook <keescook@chromium.org>

As an aside, Dan, how hard would this kind of mismatch be to detect with smatch?

-Kees

> ---
>  fs/befs/linuxvfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
> index e9c75e2..d714dda 100644
> --- a/fs/befs/linuxvfs.c
> +++ b/fs/befs/linuxvfs.c
> @@ -319,8 +319,8 @@ static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
>         befs_debug(sb, "---> befs_read_inode() " "inode = %lu", ino);
>
>         inode = iget_locked(sb, ino);
> -       if (IS_ERR(inode))
> -               return inode;
> +       if (!inode)
> +               return ERR_PTR(-ENOMEM);
>         if (!(inode->i_state & I_NEW))
>                 return inode;
>
>



-- 
Kees Cook
Chrome OS Security
