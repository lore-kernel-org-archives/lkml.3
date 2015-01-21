Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbbAUKBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:01:49 -0500
Received: from mail-yk0-f179.google.com ([209.85.160.179]:38179 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbbAUKBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:01:44 -0500
MIME-Version: 1.0
In-Reply-To: <1419072462-3168-6-git-send-email-prabhakar.csengg@gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
	<1419072462-3168-6-git-send-email-prabhakar.csengg@gmail.com>
Date: Wed, 21 Jan 2015 18:01:43 +0800
Message-ID: <CAHG8p1D4HAbM-JVDa_P81EA1TeSYZ_Wi5=uYH5VvnmLiR+dHeA@mail.gmail.com>
Subject: Re: [PATCH 05/15] media: blackfin: bfin_capture: improve
 queue_setup() callback
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-20 18:47 GMT+08:00 Lad, Prabhakar <prabhakar.csengg@gmail.com>:
> this patch improves the queue_setup() callback.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/blackfin/bfin_capture.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 8bd94a1..76d42bb 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -44,7 +44,6 @@
>  #include <media/blackfin/ppi.h>
>
>  #define CAPTURE_DRV_NAME        "bfin_capture"
> -#define BCAP_MIN_NUM_BUF        2
>
>  struct bcap_format {
>         char *desc;
> @@ -292,11 +291,14 @@ static int bcap_queue_setup(struct vb2_queue *vq,
>  {
>         struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
>
> -       if (*nbuffers < BCAP_MIN_NUM_BUF)
> -               *nbuffers = BCAP_MIN_NUM_BUF;
> +       if (fmt && fmt->fmt.pix.sizeimage < bcap_dev->fmt.sizeimage)
> +               return -EINVAL;
> +
> +       if (vq->num_buffers + *nbuffers < 3)
> +               *nbuffers = 3 - vq->num_buffers;

It seems it changes the minimum buffers from 2 to 3?

>
>         *nplanes = 1;
> -       sizes[0] = bcap_dev->fmt.sizeimage;
> +       sizes[0] = fmt ? fmt->fmt.pix.sizeimage : bcap_dev->fmt.sizeimage;
>         alloc_ctxs[0] = bcap_dev->alloc_ctx;
>
