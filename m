Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbbAFTNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:13:40 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33060 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbbAFTNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:13:39 -0500
MIME-Version: 1.0
In-Reply-To: <1420566526-30471-1-git-send-email-salyzyn@android.com>
References: <1420566526-30471-1-git-send-email-salyzyn@android.com>
Date: Tue, 6 Jan 2015 11:13:38 -0800
X-Google-Sender-Auth: 7IxJne-Eu3Q8qRfGeWNvaeZih3g
Message-ID: <CAGXu5jKgGvD8DkVptiDPeQmPECDVJEhLJJjp0ZtnE3dqm6hE1A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] pstore: use scnprintf
From: Kees Cook <keescook@chromium.org>
To: Mark Salyzyn <salyzyn@android.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 9:48 AM, Mark Salyzyn <salyzyn@android.com> wrote:
> No guarantees that the names will not exceed the
> name buffer with future adjustments.
>
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

> ---
>  fs/pstore/inode.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index 5041660..1948567 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -338,32 +338,35 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>
>         switch (type) {
>         case PSTORE_TYPE_DMESG:
> -               sprintf(name, "dmesg-%s-%lld%s", psname, id,
> -                                               compressed ? ".enc.z" : "");
> +               scnprintf(name, sizeof(name), "dmesg-%s-%lld%s",
> +                         psname, id, compressed ? ".enc.z" : "");
>                 break;
>         case PSTORE_TYPE_CONSOLE:
> -               sprintf(name, "console-%s-%lld", psname, id);
> +               scnprintf(name, sizeof(name), "console-%s-%lld", psname, id);
>                 break;
>         case PSTORE_TYPE_FTRACE:
> -               sprintf(name, "ftrace-%s-%lld", psname, id);
> +               scnprintf(name, sizeof(name), "ftrace-%s-%lld", psname, id);
>                 break;
>         case PSTORE_TYPE_MCE:
> -               sprintf(name, "mce-%s-%lld", psname, id);
> +               scnprintf(name, sizeof(name), "mce-%s-%lld", psname, id);
>                 break;
>         case PSTORE_TYPE_PPC_RTAS:
> -               sprintf(name, "rtas-%s-%lld", psname, id);
> +               scnprintf(name, sizeof(name), "rtas-%s-%lld", psname, id);
>                 break;
>         case PSTORE_TYPE_PPC_OF:
> -               sprintf(name, "powerpc-ofw-%s-%lld", psname, id);
> +               scnprintf(name, sizeof(name), "powerpc-ofw-%s-%lld",
> +                         psname, id);
>                 break;
>         case PSTORE_TYPE_PPC_COMMON:
> -               sprintf(name, "powerpc-common-%s-%lld", psname, id);
> +               scnprintf(name, sizeof(name), "powerpc-common-%s-%lld",
> +                         psname, id);
>                 break;
>         case PSTORE_TYPE_UNKNOWN:
> -               sprintf(name, "unknown-%s-%lld", psname, id);
> +               scnprintf(name, sizeof(name), "unknown-%s-%lld", psname, id);
>                 break;
>         default:
> -               sprintf(name, "type%d-%s-%lld", type, psname, id);
> +               scnprintf(name, sizeof(name), "type%d-%s-%lld",
> +                         type, psname, id);
>                 break;
>         }
>
> --
> 2.2.0.rc0.207.ga3a616c
>



-- 
Kees Cook
Chrome OS Security
