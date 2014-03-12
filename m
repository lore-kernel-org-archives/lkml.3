Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaCLQuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:50:35 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:32894 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaCLQue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:50:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140312132441.GA29079@shuo-gentoo>
References: <20140312132441.GA29079@shuo-gentoo>
Date: Wed, 12 Mar 2014 09:50:33 -0700
X-Google-Sender-Auth: wyuyYb-tJoMzSU73SMftgKU2OP8
Message-ID: <CAGXu5j+Ka0SiP_wRHENjordFjm5G4RYiQQunAMt8PrM63S9u9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] pstore: fix buffer overflow while write offset equal
 to buffer size
From: Kees Cook <keescook@chromium.org>
To: Liu Shuo <shuox.liu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Zhang Yanmin <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 6:24 AM, Liu Shuo <shuox.liu@gmail.com> wrote:
> From: Liu ShuoX <shuox.liu@intel.com>
>
> In case new offset is equal to prz->buffer_size, it won't wrap at this
> time and will return old(overflow) value next time.
>
> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>

This seems correct; good catch. Have you seen this problem happen, or
is this just from reading the code?

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
> fs/pstore/ram_core.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
> index de272d4..ff7e3d4 100644
> --- a/fs/pstore/ram_core.c
> +++ b/fs/pstore/ram_core.c
> @@ -54,7 +54,7 @@ static size_t buffer_start_add_atomic(struct
> persistent_ram_zone *prz, size_t a)
>         do {
>                 old = atomic_read(&prz->buffer->start);
>                 new = old + a;
> -               while (unlikely(new > prz->buffer_size))
> +               while (unlikely(new >= prz->buffer_size))
>                         new -= prz->buffer_size;
>         } while (atomic_cmpxchg(&prz->buffer->start, old, new) != old);
>
> @@ -91,7 +91,7 @@ static size_t buffer_start_add_locked(struct
> persistent_ram_zone *prz, size_t a)
>
>         old = atomic_read(&prz->buffer->start);
>         new = old + a;
> -       while (unlikely(new > prz->buffer_size))
> +       while (unlikely(new >= prz->buffer_size))
>                 new -= prz->buffer_size;
>         atomic_set(&prz->buffer->start, new);
>
> --
> 1.8.3.2
>
>
>



-- 
Kees Cook
Chrome OS Security
