Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab3IDSax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:30:53 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:44365 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3IDSaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:30:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130904182747.GB7024@begonia>
References: <dd275081395986c38e577b6db4c4dd8cb42dde93.1377193658.git.luto@amacapital.net>
 <20130904182747.GB7024@begonia>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 4 Sep 2013 11:30:31 -0700
Message-ID: <CALCETrU21MEmSkkrm4VVVGpUPd21GTMJ5VRhHj2MRBxbYtxHyQ@mail.gmail.com>
Subject: Re: [PATCH] Ensure prepare_update_cmtime() returns an initialized
 value (was: Re: [PATCH v4 2/7] fs: Add inode_update_time_writable)
To: "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll integrate that into v5.

--Andy

On Wed, Sep 4, 2013 at 11:27 AM, Sylvain 'ythier' Hitier
<sylvain.hitier@gmail.com> wrote:
> Hello,
>
> This is to apply on top of
> "[PATCH v4 2/7] fs: Add inode_update_time_writable"
> dated Thu, 22 Aug 2013 17:03:18 -0700
>
>
>
> Ensure prepare_update_cmtime() returns an initialized value.
>
> While at it:
>   - always use sync_it var as a bitfield
>   - remove useless test
>
> Signed-off-by: Sylvain "ythier" Hitier <sylvain.hitier@gmail.com>
> ---
>  fs/inode.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/fs/inode.c b/fs/inode.c
> index 2bbcb19..edf225c 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1643,7 +1643,7 @@ EXPORT_SYMBOL(file_remove_suid);
>   */
>  static int prepare_update_cmtime(struct inode *inode, struct timespec *now)
>  {
> -       int sync_it;
> +       int sync_it = 0;
>
>         /* First try to exhaust all avenues to not sync */
>         if (IS_NOCMTIME(inode))
> @@ -1651,7 +1651,7 @@ static int prepare_update_cmtime(struct inode *inode, struct timespec *now)
>
>         *now = current_fs_time(inode->i_sb);
>         if (!timespec_equal(&inode->i_mtime, now))
> -               sync_it = S_MTIME;
> +               sync_it |= S_MTIME;
>
>         if (!timespec_equal(&inode->i_ctime, now))
>                 sync_it |= S_CTIME;
> @@ -1659,9 +1659,6 @@ static int prepare_update_cmtime(struct inode *inode, struct timespec *now)
>         if (IS_I_VERSION(inode))
>                 sync_it |= S_VERSION;
>
> -       if (!sync_it)
> -               return 0;
> -
>         return sync_it;
>  }
>
>
> Regards,
> Sylvain "ythier" Hitier
>
> --
> Business is about being busy, not being rich...
> Lived 777 days in a Debian package => http://en.wikipedia.org/wiki/Apt,_Vaucluse
> There's THE room for ideals in this mechanical place!



-- 
Andy Lutomirski
AMA Capital Management, LLC
