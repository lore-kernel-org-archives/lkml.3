Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbbA0OQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:16:56 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:42183 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbbA0OQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:16:52 -0500
MIME-Version: 1.0
In-Reply-To: <1422362302-25252-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1422362302-25252-1-git-send-email-sudipm.mukherjee@gmail.com>
Date: Tue, 27 Jan 2015 09:16:51 -0500
Message-ID: <CAECXXi7Y8XPWHaP+p67WY9GO+r5ztmmtKxF_HKFxqcE56cUieQ@mail.gmail.com>
Subject: Re: [PATCH v2] nbd: fix possible memory leak
From: Paul Clements <paul.clements@us.sios.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 7:38 AM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> we have already allocated memory for nbd_dev, but we were not
> releasing that memory and just returning the error value.
>
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Looks good to me.

Acked-by: Paul Clements <Paul.Clements@SteelEye.com>

> ---
>
> v2: moved kcalloc after the returns.
>
>  drivers/block/nbd.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 4bc2a5c..db93c75 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -803,10 +803,6 @@ static int __init nbd_init(void)
>                 return -EINVAL;
>         }
>
> -       nbd_dev = kcalloc(nbds_max, sizeof(*nbd_dev), GFP_KERNEL);
> -       if (!nbd_dev)
> -               return -ENOMEM;
> -
>         part_shift = 0;
>         if (max_part > 0) {
>                 part_shift = fls(max_part);
> @@ -827,6 +823,10 @@ static int __init nbd_init(void)
>
>         if (nbds_max > 1UL << (MINORBITS - part_shift))
>                 return -EINVAL;
> +
> +       nbd_dev = kcalloc(nbds_max, sizeof(*nbd_dev), GFP_KERNEL);
> +       if (!nbd_dev)
> +               return -ENOMEM;
>
>         for (i = 0; i < nbds_max; i++) {
>                 struct gendisk *disk = alloc_disk(1 << part_shift);
> --
> 1.8.1.2
>
