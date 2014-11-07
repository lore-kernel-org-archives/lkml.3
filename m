Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaKGMQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:16:01 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:39898 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaKGMQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:16:00 -0500
MIME-Version: 1.0
In-Reply-To: <1415279067-653-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1415279067-653-1-git-send-email-sudipm.mukherjee@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 7 Nov 2014 12:08:59 +0000
Message-ID: <CA+V-a8vk3Ct8wGCsqzr4Bj9ACw__E0wB1-HuYNfohV847d7ycA@mail.gmail.com>
Subject: Re: [PATCH] media: davinci: vpbe: missing clk_put
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the patch!

On Thu, Nov 6, 2014 at 1:04 PM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> we are getting struct clk using clk_get before calling
> clk_prepare_enable. but if clk_prepare_enable fails, then we are
> jumping to fail_mutex_unlock where we are just unlocking the mutex,
> but we are not freeing the clock source.
> this patch just adds a call to clk_put before jumping to
> fail_mutex_unlock.
>
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks,
--Prabhakar

> ---
>  drivers/media/platform/davinci/vpbe.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> index 49d2de0..e5df991 100644
> --- a/drivers/media/platform/davinci/vpbe.c
> +++ b/drivers/media/platform/davinci/vpbe.c
> @@ -625,6 +625,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>                 }
>                 if (clk_prepare_enable(vpbe_dev->dac_clk)) {
>                         ret =  -ENODEV;
> +                       clk_put(vpbe_dev->dac_clk);
>                         goto fail_mutex_unlock;
>                 }
>         }
> --
> 1.8.1.2
>
