Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3FARLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 13:11:40 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51828 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3FARLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 13:11:32 -0400
MIME-Version: 1.0
In-Reply-To: <1370079602.29224.8.camel@localhost.localdomain>
References: <1370079602.29224.8.camel@localhost.localdomain>
Date: Sat, 1 Jun 2013 10:11:31 -0700
X-Google-Sender-Auth: yTxjSFlfT_wIYkme0HEy78m-DLc
Message-ID: <CAGXu5jK_mK_SCDQCQnG=y-yphy7kUT+on0pZbv4JpjS7jjpGwQ@mail.gmail.com>
Subject: Re: [PATCH] efi, pstore: Cocci spatch "memdup.spatch"
From: Kees Cook <keescook@chromium.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Matt Fleming <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 2:40 AM, Thomas Meyer <thomas@m3y3r.de> wrote:
>
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

> ---
>
> diff -u -p a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> --- a/drivers/firmware/efi/efi-pstore.c
> +++ b/drivers/firmware/efi/efi-pstore.c
> @@ -79,10 +79,9 @@ static int efi_pstore_read_func(struct e
>                            &entry->var.DataSize, entry->var.Data);
>         size = entry->var.DataSize;
>
> -       *cb_data->buf = kmalloc(size, GFP_KERNEL);
> +       *cb_data->buf = kmemdup(entry->var.Data, size, GFP_KERNEL);
>         if (*cb_data->buf == NULL)
>                 return -ENOMEM;
> -       memcpy(*cb_data->buf, entry->var.Data, size);
>         return size;
>  }
>
>
>
>



--
Kees Cook
Chrome OS Security
