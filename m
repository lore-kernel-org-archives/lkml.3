Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284AbbA2K2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:28:01 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55575 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758273AbbA2K16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:27:58 -0500
MIME-Version: 1.0
In-Reply-To: <1422257225-22037-1-git-send-email-der.herr@hofr.at>
References: <1422257225-22037-1-git-send-email-der.herr@hofr.at>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 29 Jan 2015 10:27:27 +0000
Message-ID: <CA+V-a8uy-WAB6-LOudtGBxMW9wkBkmoVj7S+k7F33pQp36k8jw@mail.gmail.com>
Subject: Re: [PATCH RFC] staging: media: davinci_vpfe: drop condition with no effect
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, Jiayi Ye <yejiayily@gmail.com>,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        linux-media <linux-media@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 7:27 AM, Nicholas Mc Guire <der.herr@hofr.at> wrote:
> As the if and else branch body are identical the condition has no effect and
> can be dropped.
>
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
>
> As the if and the else branch of the inner conditional paths are the same
> the condition is without effect. Given the comments indicate that
> the else branch *should* be handling a specific case this may indicate
> a bug, in which case the below patch is *wrong*. This needs a review by
> someone that knows the specifics of this driver.
>
> If the inner if/else is a placeholder for planed updates then it should
> be commented so this is clear.
>
> Patch was only compile tested with davinci_all_defconfig + CONFIG_STAGING=y
> CONFIG_STAGING_MEDIA=y, CONFIG_MEDIA_SUPPORT=m,
> CONFIG_MEDIA_ANALOG_TV_SUPPORT=y, CONFIG_MEDIA_CAMERA_SUPPORT=y
> CONFIG_MEDIA_CONTROLLER=y, CONFIG_VIDEO_V4L2_SUBDEV_API=y
> CONFIG_VIDEO_DM365_VPFE=m
>
> Patch is against 3.0.19-rc5 -next-20150123
>
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c |    9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> index 75e70e1..bf2cb7a 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> @@ -63,16 +63,11 @@ resizer_calculate_line_length(u32 pix, int width, int height,
>         if (pix == MEDIA_BUS_FMT_UYVY8_2X8 ||
>             pix == MEDIA_BUS_FMT_SGRBG12_1X12) {
>                 *line_len = width << 1;
> -       } else if (pix == MEDIA_BUS_FMT_Y8_1X8 ||
> -                  pix == MEDIA_BUS_FMT_UV8_1X8) {
> -               *line_len = width;
> -               *line_len_c = width;
> -       } else {
> -               /* YUV 420 */
> -               /* round width to upper 32 byte boundary */
> +       } else {
>                 *line_len = width;
>                 *line_len_c = width;
>         }
> +
>         /* adjust the line len to be a multiple of 32 */
>         *line_len += 31;
>         *line_len &= ~0x1f;
> --
> 1.7.10.4
>
