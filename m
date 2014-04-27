Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaD0LEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 07:04:16 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:38445 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaD0LEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 07:04:14 -0400
MIME-Version: 1.0
In-Reply-To: <CALkh-HgA3rPpgTGrBDrY4v5w4xXgmtA=-PKbWGBG-eB_0sWoVw@mail.gmail.com>
References: <CALkh-HgA3rPpgTGrBDrY4v5w4xXgmtA=-PKbWGBG-eB_0sWoVw@mail.gmail.com>
Date: Sun, 27 Apr 2014 13:04:13 +0200
Message-ID: <CAFLxGvzOobytf_SEQmmKGrC-buVyh4C5KqD1O56wnrqaHB3KLw@mail.gmail.com>
Subject: Re: [PATCH] do_mounts: fix not all available filesystems get tried
 during boot
From: Richard Weinberger <richard.weinberger@gmail.com>
To: =?UTF-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?= 
	<plamen.sisi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:37 PM, Пламен Петров <plamen.sisi@gmail.com> wrote:
> While debugging a kernel panic with 3.14.1 it became clear that some
> changes made some filesystems mount routines return error codes other
> than 0, EACCES and EINVAL. Such return codes result in the kernel
> panicking without trying to mount root with all of the available
> filesystems, as can be seen in bugzilla entries 74901 and 74261.

What filesystems are these?

> Make mount_block_root continue trying other available filesystems by
> default, not only when the last tried returned EACCES or EINVAL.
>
> Signed-off-by: Plamen Petrov <plamen.sisi@gmail.com>
> ---
>  init/do_mounts.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index 09ded58..a4abbdf 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -403,7 +403,7 @@ retry:
>                         case -EACCES:
>                                 flags |= MS_RDONLY;
>                                 goto retry;
> -                       case -EINVAL:
> +                       default:
>                                 continue;
>                 }
>                 /*
> --
> 1.9.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
