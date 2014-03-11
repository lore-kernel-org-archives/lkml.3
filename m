Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbaCKUbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:31:05 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:42095 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbaCKUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:31:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140311061519.GA11552@lskakaxi-intel>
References: <20140311061519.GA11552@lskakaxi-intel>
Date: Tue, 11 Mar 2014 13:30:59 -0700
X-Google-Sender-Auth: fECwUuZLUD9CfrF3vDBq1rU48Bc
Message-ID: <CAGXu5j+oYp7-1mOmQXrEcDhH5YY-Zm5fa4ccHZMNH_kwJVB9VQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] pstore: fix NULL pointer fault if get NULL prz in ramoops_get_next_prz
From: Kees Cook <keescook@chromium.org>
To: Liu ShuoX <shuox.liu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        yanmin_zhang@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 11:15 PM, Liu ShuoX <shuox.liu@intel.com> wrote:
> These two patches are applied on top of patches:
> https://lkml.org/lkml/2014/3/3/368
> It has been added in -mm tree. Below is the first patch, and i will
> send the second by replying this one.
>
> From: Liu ShuoX <shuox.liu@intel.com>
>
> ramoops_get_next_prz get the prz according the paramters. If it get a
> uninitialized prz, access its members by following
> persistent_ram_old_size(prz)
> will cause a NULL pointer crash.
> Ex: if ftrace_size is 0, fprz will be NULL.
>
> Fix it by return NULL in advance.
>
> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>

Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  fs/pstore/ram.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 1daed28..6f96d8c 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -119,6 +119,8 @@ ramoops_get_next_prz(struct persistent_ram_zone *przs[],
> uint *c, uint max,
>                 return NULL;
>         prz = przs[i];
> +       if (!prz)
> +               return NULL;
>         /* Update old/shadowed buffer. */
>         if (update)
> --
> 1.8.3.2



-- 
Kees Cook
Chrome OS Security
