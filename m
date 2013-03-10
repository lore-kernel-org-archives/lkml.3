Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3CJXXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 19:23:04 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:57767 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3CJXXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 19:23:03 -0400
MIME-Version: 1.0
In-Reply-To: <1362830248-7017-1-git-send-email-gheorghiuandru@gmail.com>
References: <1362830248-7017-1-git-send-email-gheorghiuandru@gmail.com>
Date: Sun, 10 Mar 2013 16:23:01 -0700
X-Google-Sender-Auth: QZnPRrU13y74WUle2JTLYfnDP3Q
Message-ID: <CAGXu5jLakegTD5KPmpJviWtRJ2UgRUX7v+q2+BrsGZknzOLA0Q@mail.gmail.com>
Subject: Re: [PATCH] fs: pstore: Replaced calls to kmalloc and memcpy with kmemdup
From: Kees Cook <keescook@chromium.org>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 9, 2013 at 3:57 AM, Alexandru Gheorghiu
<gheorghiuandru@gmail.com> wrote:
> Replaced calls to kmalloc and memcpy with a single call to kmemdup.
> This patch was found using coccicheck.
>
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  fs/pstore/ram.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 288f068..38babb3 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -156,10 +156,9 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>         time->tv_nsec = 0;
>
>         size = persistent_ram_old_size(prz);
> -       *buf = kmalloc(size, GFP_KERNEL);
> +       *buf = kmemdup(persistent_ram_old(prz), size, GFP_KERNEL);
>         if (*buf == NULL)
>                 return -ENOMEM;
> -       memcpy(*buf, persistent_ram_old(prz), size);
>
>         return size;
>  }

Looks fine to me. Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
