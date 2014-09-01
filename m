Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaIALZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:25:53 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33800 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaIALZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:25:52 -0400
MIME-Version: 1.0
In-Reply-To: <1409068819-11273-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1409068819-11273-1-git-send-email-ricardo.ribalda@gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 1 Sep 2014 13:25:31 +0200
Message-ID: <CAPybu_0h+7PmUj3x+1ba5S3hnWQd3VH77_Y-u=pe7qhR9KsUUg@mail.gmail.com>
Subject: Re: [PATCH v2] usb: gadget: net2280: Fix invalid handling of Reset irq
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felipe

I think that you have forgotten about this patch :). It is needed by
usb3380 in usb3.0 mode. Otherwise the device keeps reseting.

Thanks!

On Tue, Aug 26, 2014 at 6:00 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Without this patch, some hosts keep restarting indefinitely the target.
>
> Fixes: ae8e530 (usb: gadget: net2280: Code Cleanup)
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>
> v2: Request by Felipe Balbi
>
> Use Fixes: on commit message
>
>  drivers/usb/gadget/udc/net2280.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
> index f4eac11..2e95715 100644
> --- a/drivers/usb/gadget/udc/net2280.c
> +++ b/drivers/usb/gadget/udc/net2280.c
> @@ -3320,7 +3320,7 @@ static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
>         if (stat & tmp) {
>                 writel(tmp, &dev->regs->irqstat1);
>                 if ((((stat & BIT(ROOT_PORT_RESET_INTERRUPT)) &&
> -                               (readl(&dev->usb->usbstat) & mask)) ||
> +                               ((readl(&dev->usb->usbstat) & mask) == 0)) ||
>                                 ((readl(&dev->usb->usbctl) &
>                                         BIT(VBUS_PIN)) == 0)) &&
>                                 (dev->gadget.speed != USB_SPEED_UNKNOWN)) {
> --
> 2.1.0
>



-- 
Ricardo Ribalda
