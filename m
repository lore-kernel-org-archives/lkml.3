Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3IZLOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:14:42 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:55798 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab3IZLOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:14:40 -0400
MIME-Version: 1.0
In-Reply-To: <1379755816-21822-1-git-send-email-valentin.ilie@gmail.com>
References: <1379755816-21822-1-git-send-email-valentin.ilie@gmail.com>
Date: Thu, 26 Sep 2013 14:14:39 +0300
X-Google-Sender-Auth: KqQN4MesVtQS78IB1aQuTf7gQ_4
Message-ID: <CAHuBVBa-vMT4Bx1oAxVGnMgyh5ZkreRzW052OtemZyaZpL6LWg@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: mv_u3d_core: fix memory leaks
From: Valentin Ilie <valentin.ilie@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 September 2013 12:30, Valentin Ilie <valentin.ilie@gmail.com> wrote:
> When trb_hw is NULL, trb should be free'd before return.
>
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
> ---
>  drivers/usb/gadget/mv_u3d_core.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/usb/gadget/mv_u3d_core.c b/drivers/usb/gadget/mv_u3d_core.c
> index 561b30e..4d31177 100644
> --- a/drivers/usb/gadget/mv_u3d_core.c
> +++ b/drivers/usb/gadget/mv_u3d_core.c
> @@ -310,6 +310,7 @@ static struct mv_u3d_trb *mv_u3d_build_trb_one(struct mv_u3d_req *req,
>          */
>         trb_hw = dma_pool_alloc(u3d->trb_pool, GFP_ATOMIC, dma);
>         if (!trb_hw) {
> +               kfree(trb);
>                 dev_err(u3d->dev,
>                         "%s, dma_pool_alloc fail\n", __func__);
>                 return NULL;
> @@ -454,6 +455,7 @@ static int mv_u3d_req_to_trb(struct mv_u3d_req *req)
>
>                 trb_hw = kcalloc(trb_num, sizeof(*trb_hw), GFP_ATOMIC);
>                 if (!trb_hw) {
> +                       kfree(trb);
>                         dev_err(u3d->dev,
>                                         "%s, trb_hw alloc fail\n", __func__);
>                         return -ENOMEM;
> --
> 1.7.9.5
>

Can anyone look into this?

Thank you

-- 
Valentin Ilie
+(40) 746 188 558
