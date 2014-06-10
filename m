Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaFJQgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:36:03 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37591 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaFJQgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:36:00 -0400
MIME-Version: 1.0
In-Reply-To: <1402101088-14731-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402101088-14731-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 10 Jun 2014 17:35:28 +0100
Message-ID: <CA+V-a8sBuxk9iEe-3O7cCF6NJrbE1svv0BqVw1Yu2HAncxB0MQ@mail.gmail.com>
Subject: Re: [PATCH] media: v4l2-core: v4l2-dv-timings.c: Cleaning up code
 that putting values to the same variable twice
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Martin Bugge <marbugge@cisco.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

Thanks for the patch.

On Sat, Jun 7, 2014 at 1:31 AM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Instead of putting the same variable twice,
> was rather intended to set this value to two different variable.
>
> This was partly found using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

The commit message and header needs to be improved, apart from that rest of the
patch looks good.

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
>  drivers/media/v4l2-core/v4l2-dv-timings.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
> index 48b20df..eb3850c 100644
> --- a/drivers/media/v4l2-core/v4l2-dv-timings.c
> +++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
> @@ -599,10 +599,10 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait)
>                 aspect.denominator = 9;
>         } else if (ratio == 34) {
>                 aspect.numerator = 4;
> -               aspect.numerator = 3;
> +               aspect.denominator = 3;
>         } else if (ratio == 68) {
>                 aspect.numerator = 15;
> -               aspect.numerator = 9;
> +               aspect.denominator = 9;
>         } else {
>                 aspect.numerator = hor_landscape + 99;
>                 aspect.denominator = 100;
> --
> 1.7.10.4
>
