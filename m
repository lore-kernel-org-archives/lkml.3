Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaCZQ4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:56:38 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42132 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136AbaCZQ4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:56:35 -0400
MIME-Version: 1.0
In-Reply-To: <1394007599-31429-1-git-send-email-jon@ringle.org>
References: <1394007599-31429-1-git-send-email-jon@ringle.org>
Date: Wed, 26 Mar 2014 12:56:33 -0400
X-Google-Sender-Auth: rb7-DheiMN2VjKD-FMG0SP9KrMk
Message-ID: <CAMwGMjyobE5HXLyM0Eb7=5sLvS3H0FcEUPOMfwKEdd+adW4gcA@mail.gmail.com>
Subject: Re: [PATCH] video: da8xx-fb: Fix casting of info->pseudo_palette
From: Jon Ringle <jon@ringle.org>
To: linux-fbdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jon Ringle <jringle@gridpoint.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've not heard anything regarding this patch. I just want to make sure
it's not lost :)

Jon


On Wed, Mar 5, 2014 at 3:19 AM,  <jon@ringle.org> wrote:
> From: Jon Ringle <jringle@gridpoint.com>
>
> (Resending without corporate disclaimer in email footer)
>
> The casting to (u16 *) on info->pseudo_palette is wrong and causes the
> display to show a blue (garbage) vertical line on every other pixel column
>
> Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> ---
>  drivers/video/da8xx-fb.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
>
> diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
> index d042624..83c43b2 100644
> --- a/drivers/video/da8xx-fb.c
> +++ b/drivers/video/da8xx-fb.c
> @@ -678,15 +678,7 @@ static int fb_setcolreg(unsigned regno, unsigned red, unsigned green,
>                         (green << info->var.green.offset) |
>                         (blue << info->var.blue.offset);
>
> -               switch (info->var.bits_per_pixel) {
> -               case 16:
> -                       ((u16 *) (info->pseudo_palette))[regno] = v;
> -                       break;
> -               case 24:
> -               case 32:
> -                       ((u32 *) (info->pseudo_palette))[regno] = v;
> -                       break;
> -               }
> +               ((u32 *) (info->pseudo_palette))[regno] = v;
>                 if (palette[0] != 0x4000) {
>                         update_hw = 1;
>                         palette[0] = 0x4000;
> --
> 1.8.5.4
>
