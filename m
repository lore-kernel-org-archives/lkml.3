Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbbAAPN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 10:13:59 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:36264 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbAAPN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 10:13:58 -0500
MIME-Version: 1.0
In-Reply-To: <1420088862-3549-1-git-send-email-waydi1@gmail.com>
References: <1420088862-3549-1-git-send-email-waydi1@gmail.com>
Date: Thu, 1 Jan 2015 16:13:57 +0100
Message-ID: <CAFLxGvxWoC_mekWjLQhrk9dExNUHKJ1vB+vT6HMV=xJ=DYm+Kg@mail.gmail.com>
Subject: Re: [PATCH] ovl: Prevent rw remount when it should be ro mount
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Seunghun Lee <waydi1@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 6:07 AM, Seunghun Lee <waydi1@gmail.com> wrote:
> Overlayfs should be mounted read-only when upper fs is r/o or nonexistend.
> But now it can be remounted read-write and this can causes kernel panic.
> So we should prevent read-write remount when the above situation.
>
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>

This patch makes zero sense, did you use the wrong diff?

> ---
>  fs/overlayfs/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 84f3144..1faa5e5 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -522,6 +522,14 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         return 0;
>  }
>
> +static int squashfs_remount(struct super_block *sb, int *flags, char *data)
> +{
> +       if (!ufs->upper_mnt || (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY))
> +               *flags |= MS_RDONLY;
> +
> +       return 0;
> +}
> +
>  static const struct super_operations ovl_super_operations = {
>         .put_super      = ovl_put_super,
>         .statfs         = ovl_statfs,
> --
> 2.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
