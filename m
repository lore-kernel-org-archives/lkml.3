Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbaESPyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:54:09 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:53208 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaESPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:54:05 -0400
MIME-Version: 1.0
In-Reply-To: <1400506776-2816-2-git-send-email-george.cherian@ti.com>
References: <1400506776-2816-1-git-send-email-george.cherian@ti.com>
	<1400506776-2816-2-git-send-email-george.cherian@ti.com>
Date: Mon, 19 May 2014 10:54:04 -0500
Message-ID: <CADYTM3bd8Bq5QTn-HC4jYX-owEw_sF1DOtXsc-cMDqKHGJHXjQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] usb: musb: core: Handle Babble condition only in
 HOST mode
From: Bin Liu <binmlist@gmail.com>
To: George Cherian <george.cherian@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        zonque@gmail.com, b-liu@ti.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 19, 2014 at 8:39 AM, George Cherian <george.cherian@ti.com> wrote:
> BABBLE and RESET share the same interrupt. The interrupt
> is considered to be RESET if MUSB is in peripheral mode and
> as a BABBLE if MUSB is in HOST mode.
>
> Handle babble condition iff MUSB is in HOST mode.
>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  drivers/usb/musb/musb_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index 61da471..eff3c5c 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -849,7 +849,7 @@ b_host:
>         }
>
>         /* handle babble condition */
> -       if (int_usb & MUSB_INTR_BABBLE)
> +       if (int_usb & MUSB_INTR_BABBLE && is_host_active(musb))
>                 schedule_work(&musb->recover_work);

I guess my following comments are for Daniel's patch as while which
initially added the babble work.

Should this if statement be merged into the previous 'if(int_usb &
MUSB_INTR_RESET)' one, which handles the same interrupt and already
handles host and device mode respectively.

Regards,
-Bin.

>
>  #if 0
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
