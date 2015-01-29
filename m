Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256AbbA2K0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:26:44 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:32825 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055AbbA2K0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:26:42 -0500
MIME-Version: 1.0
In-Reply-To: <1422479867-3370921-4-git-send-email-arnd@arndb.de>
References: <1422479867-3370921-1-git-send-email-arnd@arndb.de> <1422479867-3370921-4-git-send-email-arnd@arndb.de>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 29 Jan 2015 10:26:08 +0000
Message-ID: <CA+V-a8tqqvvMb2V=FJ49zC=tdtG4PNhVC-WRX3WnYO_dnrY05w@mail.gmail.com>
Subject: Re: [PATCH 3/7] [media] staging/davinci/vpfe/dm365: add missing dependencies
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 9:17 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> This driver can only be built when VIDEO_V4L2_SUBDEV_API
> and VIDEO_DAVINCI_VPBE_DISPLAY are also provided by the
> kernel.
>
> drivers/staging/media/davinci_vpfe/dm365_isif.c: In function '__isif_get_format':
> drivers/staging/media/davinci_vpfe/dm365_isif.c:1410:3: error: implicit declaration of function 'v4l2_subdev_get_try_format' [-Werror=implicit-function-declaration]
>    return v4l2_subdev_get_try_format(fh, pad);
>    ^
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
>  drivers/staging/media/davinci_vpfe/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/staging/media/davinci_vpfe/Kconfig b/drivers/staging/media/davinci_vpfe/Kconfig
> index 4de2f082491d..f40a06954a92 100644
> --- a/drivers/staging/media/davinci_vpfe/Kconfig
> +++ b/drivers/staging/media/davinci_vpfe/Kconfig
> @@ -2,6 +2,8 @@ config VIDEO_DM365_VPFE
>         tristate "DM365 VPFE Media Controller Capture Driver"
>         depends on VIDEO_V4L2 && ARCH_DAVINCI_DM365 && !VIDEO_DM365_ISIF
>         depends on HAS_DMA
> +       depends on VIDEO_V4L2_SUBDEV_API
> +       depends on VIDEO_DAVINCI_VPBE_DISPLAY
>         select VIDEOBUF2_DMA_CONTIG
>         help
>           Support for DM365 VPFE based Media Controller Capture driver.
> --
> 2.1.0.rc2
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
