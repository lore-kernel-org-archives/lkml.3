Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaDFNjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 09:39:13 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60163 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaDFNjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 09:39:10 -0400
MIME-Version: 1.0
In-Reply-To: <53396AC1.10108@gmail.com>
References: <53396AC1.10108@gmail.com>
Date: Sun, 6 Apr 2014 15:39:09 +0200
X-Google-Sender-Auth: -kp7POsZF_r2VBzPb5Y_ewuarR4
Message-ID: <CAMuHMdVT9O8C0fhMbaqS2nB1jfLAZtanp6YGPU6Q-T5b7=n20Q@mail.gmail.com>
Subject: Re: [PATCH] fs/ext4/extents_status.c: fix 64-bit number truncation bug
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 3:16 PM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
> '0x7FDEADBEEF' will be truncated to 32-bit number under unicore32. Need
> append 'ULL' for it.
>
> The related warning (with allmodconfig under unicore32):
>
>     CC [M]  fs/ext4/extents_status.o
>   fs/ext4/extents_status.c: In function ‘__es_remove_extent’:
>   fs/ext4/extents_status.c:813: warning: integer constant is too large for ‘long’ type

Thanks! This is failing on all 32-bit architectures.

> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  fs/ext4/extents_status.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 0a014a7..0ebc212 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -810,7 +810,7 @@ retry:
>
>                         newes.es_lblk = end + 1;
>                         newes.es_len = len2;
> -                       block = 0x7FDEADBEEF;
> +                       block = 0x7FDEADBEEFULL;
>                         if (ext4_es_is_written(&orig_es) ||
>                             ext4_es_is_unwritten(&orig_es))
>                                 block = ext4_es_pblock(&orig_es) +

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
