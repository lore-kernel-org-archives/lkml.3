Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbaFSTtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:49:31 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:35254 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbaFSTt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:49:29 -0400
MIME-Version: 1.0
In-Reply-To: <1403207097-12124-1-git-send-email-khoroshilov@ispras.ru>
References: <1403207097-12124-1-git-send-email-khoroshilov@ispras.ru>
Date: Thu, 19 Jun 2014 13:49:28 -0600
Message-ID: <CALnQHM0wkN4RGaia8PoCRnESpY9aV=HMZCH9fuRo8W=R4o1VGw@mail.gmail.com>
Subject: Re: [PATCH] usb: host: max3421-hcd: unconditionally use GFP_ATOMIC in max3421_urb_enqueue()
From: David Mosberger <davidm@egauge.net>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 1:44 PM, Alexey Khoroshilov
<khoroshilov@ispras.ru> wrote:
> As far as kzalloc() is called with spinlock held,
> we have to pass GFP_ATOMIC regardless of mem_flags argument.

Good catch, thanks!

> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: David Mosberger <davidm@egauge.net>

> ---
>  drivers/usb/host/max3421-hcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
> index 858efcfda50b..ed22424dbec7 100644
> --- a/drivers/usb/host/max3421-hcd.c
> +++ b/drivers/usb/host/max3421-hcd.c
> @@ -1551,7 +1551,7 @@ max3421_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flags)
>         max3421_ep = urb->ep->hcpriv;
>         if (!max3421_ep) {
>                 /* gets freed in max3421_endpoint_disable: */
> -               max3421_ep = kzalloc(sizeof(struct max3421_ep), mem_flags);
> +               max3421_ep = kzalloc(sizeof(struct max3421_ep), GFP_ATOMIC);
>                 if (!max3421_ep) {
>                         retval = -ENOMEM;
>                         goto out;
> --
> 1.9.1
>



-- 
eGauge Systems LLC, http://egauge.net/, 1.877-EGAUGE1, fax 720.545.9768
