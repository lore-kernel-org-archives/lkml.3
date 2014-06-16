Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaFPG7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 02:59:48 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:62471 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaFPG7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 02:59:47 -0400
MIME-Version: 1.0
In-Reply-To: <1402506054-7696-1-git-send-email-geert@linux-m68k.org>
References: <1402506054-7696-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 16 Jun 2014 08:59:45 +0200
X-Google-Sender-Auth: Ngpm6rGNyq2QV_7mXH5Z351SYFA
Message-ID: <CAMuHMdWX9gY=6npcVk6kLRGPq+wjg545AZEvphw0hW79bsympQ@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: Use %ld to format long
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: driverdevel <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Jun 11, 2014 at 7:00 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> drivers/staging/lustre/lustre/llite/rw26.c: In function ‘ll_direct_IO_26’:
> drivers/staging/lustre/lustre/llite/rw26.c:388: warning: format ‘%zd’ expects type ‘signed size_t’, but argument 6 has type ‘long int’
> drivers/staging/lustre/lustre/llite/rw26.c:388: warning: format ‘%zd’ expects type ‘signed size_t’, but argument 10 has type ‘long int’
>
> Introduced by commit b41a1fe067c34b40736860458b9d62b2139471d5 ("staging:
> lustre: Use %zd to format ssize_t"), which was part of a series to fix
> issues in -next. However, the commits introducing the issues never made it
> to mainline.

They have now, so please drop this patch.

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/staging/lustre/lustre/llite/rw26.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/lustre/lustre/llite/rw26.c
> index 55ca8d3c3e46..5b944d3fb80c 100644
> --- a/drivers/staging/lustre/lustre/llite/rw26.c
> +++ b/drivers/staging/lustre/lustre/llite/rw26.c
> @@ -386,7 +386,7 @@ static ssize_t ll_direct_IO_26(int rw, struct kiocb *iocb,
>                 return -EINVAL;
>
>         CDEBUG(D_VFSTRACE,
> -              "VFS Op:inode=%lu/%u(%p), size=%zd (max %lu), offset=%lld=%llx, pages %zd (max %lu)\n",
> +              "VFS Op:inode=%lu/%u(%p), size=%ld (max %lu), offset=%lld=%llx, pages %ld (max %lu)\n",
>                inode->i_ino, inode->i_generation, inode, count, MAX_DIO_SIZE,
>                file_offset, file_offset, count >> PAGE_CACHE_SHIFT,
>                MAX_DIO_SIZE >> PAGE_CACHE_SHIFT);
> --
> 1.9.1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
