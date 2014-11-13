Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837AbaKMSK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:10:59 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:32975 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933491AbaKMSK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:10:58 -0500
MIME-Version: 1.0
In-Reply-To: <1415902158-18769-1-git-send-email-furquan@google.com>
References: <1415902158-18769-1-git-send-email-furquan@google.com>
Date: Thu, 13 Nov 2014 10:10:57 -0800
X-Google-Sender-Auth: AQcQeCracBtAPCxRMzFXDPemqE8
Message-ID: <CAGXu5jJTChfUPSxpUDAes6DoVrpO8yzM_XFj5QA5Qsb110Liug@mail.gmail.com>
Subject: Re: [PATCH] pstore: Use memcpy_toio instead of memcpy
From: Kees Cook <keescook@chromium.org>
To: Furquan Shaikh <furquan@google.com>
Cc: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Olof Johansson <olofj@google.com>, Aaron Durbin <adurbin@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:09 AM, Furquan Shaikh <furquan@google.com> wrote:
> persistent_ram_update uses vmap / iomap based on whether the buffer is in memory
> region or reserved region. However, both map it as non-cacheable memory. For
> armv8 specifically, non-cacheable mapping requests use a memory type that has to
> be accessed aligned to the request size. memcpy() doesn't guarantee that.
>
> Signed-off-by: Furquan Shaikh <furquan@google.com>
> ---
>  fs/pstore/ram_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
> index 9d7b9a8..cfbc5e4 100644
> --- a/fs/pstore/ram_core.c
> +++ b/fs/pstore/ram_core.c
> @@ -299,7 +299,7 @@ static void notrace persistent_ram_update(struct persistent_ram_zone *prz,
>         const void *s, unsigned int start, unsigned int count)
>  {
>         struct persistent_ram_buffer *buffer = prz->buffer;
> -       memcpy(buffer->data + start, s, count);
> +       memcpy_toio(buffer->data + start, s, count);
>         persistent_ram_update_ecc(prz, start, count);
>  }
>
> --
> 2.1.0.rc2.206.gedb03e5
>

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
